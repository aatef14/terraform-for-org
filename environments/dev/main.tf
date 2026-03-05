# This is the Heart of Specific Environment configuration.
# Use this to disable provisioning any unwanted services by selecting the module block 
# and doing Ctrl + /, which will comment out the code.
# Local variables for common settings
# locals are useful for values you want to reuse multiple times in this file
locals {
  common_tags = {
    Environment = "stg"
  }
}

# Azure VNET config (Managed in vnet.tf)

# Storage account config
module "storage_account" {
  count  = var.enable_storage_account ? 1 : 0
  source = "../../modules/storage-account"

  name                = var.storage_account_name_dev
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location



  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

# WEB APP SERVICE CONFIG
# Each app is now its own module block for granular control
module "app_service_frontend" {
  source = "../../modules/app-service"

  app_service_name      = var.app_service_name_fend
  app_service_plan_name = "asp-${var.app_service_name_fend}"
  resource_group_name   = data.azurerm_resource_group.rg_dev.name
  location              = data.azurerm_resource_group.rg_dev.location

  sku_name               = var.sku_name_fend
  zone_balancing_enabled = var.zoone_balancing_enabled_fend
  vnet_subnet_id         = module.subnet_fend_qc.subnet_id
  docker_image_name      = var.docker_image_name_fend
}

module "app_service_backend" {
  source = "../../modules/app-service"

  app_service_name      = var.app_service_name_bend
  app_service_plan_name = "asp-${var.app_service_name_bend}"
  resource_group_name   = data.azurerm_resource_group.rg_dev.name
  location              = data.azurerm_resource_group.rg_dev.location

  sku_name               = var.sku_name_bend
  zone_balancing_enabled = var.zoone_balancing_enabled_bend
  vnet_subnet_id         = module.subnet_bend_qc.subnet_id
  docker_image_name      = var.docker_image_name_bend

}


# Azure Cache for Redis config
module "redis_cache" {
  count  = var.enable_redis ? 1 : 0
  source = "../../modules/cache-for-redis"

  name                = var.redis_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku_name            = var.redis_sku
  capacity            = var.redis_capacity
  family              = var.redis_family
  minimum_tls_version = "1.2"

  shard_count         = var.redis_shard_count
  replicas_per_master = var.redis_replicas_per_master

  tags = local.common_tags
}


# FUNCTION APP CONFIG (Container Based - Premium)
# Individual block for Function App for granular control
module "function_app_1" {
  count  = var.enable_function_app ? 1 : 0
  source = "../../modules/function-app-container"

  function_name  = "func-container-premium"
  func_plan_name = "asp-func-container-premium"

  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  func_os_type        = "Linux"
  func_sku            = "EP1"
  func_zone_balancing = false

  func_storage_account_name     = "stfuncqeqispstg01"
  func_storage_account_tier     = "Standard"
  func_account_replication_type = "LRS"
  func_account_kind             = "StorageV2"

  func_image_name   = "appsvc/staticsite"
  func_image_tag    = "latest"
  func_registry_url = "https://mcr.microsoft.com"

  vnet_subnet_id = module.subnet_func_sc.subnet_id
  tags           = local.common_tags
}


# Azure Key Vault
data "azurerm_client_config" "current" {}

module "key_vault" {
  count  = var.enable_key_vault ? 1 : 0
  source = "../../modules/key-vault"


  key_vault_name      = var.key_vault_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  key_vault_sku_name  = var.key_vault_sku_name
}


# Azure API Management
module "apim" {
  count  = var.enable_apim ? 1 : 0
  source = "../../modules/apim"

  name                = var.apim_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = var.sku_name

  depends_on = [module.service_bus]
}

# Azure Service Bus
module "service_bus" {
  count  = var.enable_service_bus ? 1 : 0
  source = "../../modules/service-bus"

  name                         = var.service_bus_name
  location                     = data.azurerm_resource_group.rg_dev.location
  resource_group_name          = data.azurerm_resource_group.rg_dev.name
  capacity                     = var.service_bus_capacity
  sbus_sku_name                = var.sbus_sku_name
  premium_messaging_partitions = var.premium_messaging_partitions
}

# Azure Cosmos DB
module "cosmos_db" {
  count  = var.enable_cosmos_db ? 1 : 0
  source = "../../modules/cosmos-db"

  name                            = var.cosmos_db_name
  resource_group_name             = data.azurerm_resource_group.rg_dev.name
  location                        = data.azurerm_resource_group.rg_dev.location
  throughput                      = var.cosmos_db_throughput
  zone_redundant                  = var.cosmos_db_zone_redundant
  db_name                         = var.cosmos_db_database_name
  enable_multiple_write_locations = var.cosmos_db_enable_multiple_write_locations
  cosmos_db_offer_type            = var.cosmos_db_offer_type
  cosmos_db_kind                  = var.cosmos_db_kind
  cosmos_db_free_tier_enabled     = var.cosmos_db_free_tier_enabled
  backup_type                     = var.cosmos_db_backup_type
  backup_interval_in_minutes      = var.cosmos_db_backup_interval_in_minutes
  backup_retention_in_hours       = var.cosmos_db_backup_retention_in_hours
  backup_storage_redundancy       = var.cosmos_db_backup_storage_redundancy
}

# Azure PostgreSQL Flexible Server
module "postgresql" {
  count  = var.enable_postgresql ? 1 : 0
  source = "../../modules/postgresql"

  name                = var.postgresql_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  administrator_login    = var.postgresql_admin_login
  administrator_password = var.postgresql_admin_password
  sku_name               = var.postgresql_sku
  storage_mb             = var.postgresql_storage_mb

  tags = local.common_tags
}

# Azure Event Grid Namespace
module "event_grid" {
  count  = var.enable_event_grid ? 1 : 0
  source = "../../modules/event-grid"

  name                = var.event_grid_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku      = var.event_grid_sku
  capacity = var.event_grid_capacity

  public_network_access_enabled = var.event_grid_public_network_access

  tags = local.common_tags
}

# Azure Logic App Standard
module "logic_app" {
  count  = var.enable_logic_app ? 1 : 0
  source = "../../modules/logic-app"

  name                = var.logic_app_name
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  app_service_plan_name            = "asp-${var.logic_app_name}"
  sku_name                         = var.logic_app_sku
  zone_balancing_enabled           = var.logic_app_zone_balancing
  storage_account_name             = var.logic_app_storage_name
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  virtual_network_subnet_id        = module.subnet_logic_sc.subnet_id

  tags = local.common_tags
}

# Azure Event Hub Namespace
module "event_hub" {
  count  = var.enable_event_hub ? 1 : 0
  source = "../../modules/event-hub"

  name                = var.event_hub_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku      = var.event_hub_sku
  capacity = var.event_hub_capacity

  public_network_access_enabled = var.event_hub_public_network_access

  tags = local.common_tags
}

# Azure Linux Virtual Machine
module "linux_vm" {
  count  = var.enable_vm_linux ? 1 : 0
  source = "../../modules/linux-vm"

  name                = var.vm_linux_name
  location            = var.location_qc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  size           = var.vm_linux_size
  admin_username = var.vm_linux_admin_username
  admin_password = var.vm_linux_admin_password

  os_disk_storage_account_type = "StandardSSD_LRS" # E15 corresponds to Standard SSD
  os_disk_size_gb              = 256

  tags = local.common_tags
}
