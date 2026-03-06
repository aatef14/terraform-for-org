# This is the Heart of Specific Environment configuration.
# Use this to disable provisioning any unwanted services by selecting the module block 
# and doing Ctrl + /, which will comment out the code.
# Local variables for common settings
# locals are useful for values you want to reuse multiple times in this file
locals {
  common_tags = {
    Environment = "Value"
    Project     = "value"
    Scope       = "value" # PR or DR Region
  }
}

# Azure VNET config (Managed in vnet.tf)

# Storage account config
module "storage_account" {
  for_each = var.feature_toggles["storage_account"] ? var.storage_account_config : {}
  source   = "../../modules/storage-account"

  name                = each.value.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  account_tier             = each.value.storage_account_tier
  account_replication_type = each.value.storage_account_replication_type
  account_kind             = each.value.storage_account_kind
  tags                     = local.common_tags
}

# WEB APP SERVICE CONFIG - VNET INTEGRATION - optional
module "app_service" {
  for_each = var.app_service_config
  source   = "../../modules/app-service"

  app_service_name      = each.value.app_service_name
  app_service_plan_name = "asp-${each.value.app_service_name}"
  resource_group_name   = data.azurerm_resource_group.rg_dev.name
  location              = data.azurerm_resource_group.rg_dev.location

  sku_name               = each.value.sku_name
  zone_balancing_enabled = each.value.zone_balancing_enabled
  vnet_subnet_id         = local.subnets[each.value.subnet_key] 
  docker_image_name      = each.value.docker_image_name
  tags                   = local.common_tags
}


# Azure Cache for Redis config
module "redis_cache" {
  count  = var.feature_toggles["redis"] ? 1 : 0
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


# FUNCTION APP CONFIG
module "function_app" {
  for_each = var.feature_toggles["function_app"] ? var.function_app_config : {}
  source   = "../../modules/function-app-container"

  function_name  = each.value.function_name
  func_plan_name = "asp-${each.value.function_name}"

  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  func_os_type        = each.value.func_os_type
  func_sku            = each.value.func_sku
  func_zone_balancing = each.value.func_zone_balancing

  func_storage_account_name     = each.value.func_storage_account_name
  func_storage_account_tier     = each.value.func_storage_account_tier
  func_account_replication_type = each.value.func_account_replication_type
  func_account_kind             = each.value.func_account_kind

  func_image_name   = each.value.func_image_name
  func_image_tag    = each.value.func_image_tag
  func_registry_url = each.value.func_registry_url

  vnet_subnet_id = local.subnets[each.value.subnet_key]
  tags           = local.common_tags
}


# Azure Key Vault
module "key_vault" {
  for_each = var.feature_toggles["key_vault"] ? var.key_vault : {}
  source   = "../../modules/key-vault"

  key_vault_name      = each.value.key_vault_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  key_vault_sku_name  = each.value.key_vault_sku
  tags                = local.common_tags
}


# Azure API Management
module "apim" {
  count  = var.feature_toggles["apim"] ? 1 : 0
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
  count  = var.feature_toggles["service_bus"] ? 1 : 0
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
  count  = var.feature_toggles["cosmos_db"] ? 1 : 0
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
  count  = var.feature_toggles["postgresql"] ? 1 : 0
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
  count  = var.feature_toggles["event_grid"] ? 1 : 0
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
  count  = var.feature_toggles["logic_app"] ? 1 : 0
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
  count  = var.feature_toggles["event_hub"] ? 1 : 0
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
  source = "../../modules/linux-vm"

  name                = var.vm_linux.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  size           = var.vm_linux.size
  admin_username = var.vm_linux.admin_username
  admin_password = var.vm_linux.admin_password

  subnet_id = module.subnet_pep_qc.subnet_id

  source_image = var.vm_linux.source_image

  tags = local.common_tags
}
