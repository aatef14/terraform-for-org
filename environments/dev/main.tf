# This is the Heart of Specific Environment configuration.

# To enable or disable any service, go to the terraform.tfvars file and change the value of the feature toggle

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

  # Code Explanation:
  #    - for_each = var.feature_toggles["storage_account"] ? var.storage_account_config : {}
  #    - This is a for_each expression that iterates over the storage_account_config map
  #    - var.feature_toggles["storage_account"] is a boolean value that determines whether to enable storage account
  #    - var.storage_account_config is a map of storage account configurations
  #    - The expression returns a map of storage account configurations if storage account is enabled, otherwise returns an empty map
  #    - Anything before  ? is condtionation(true/false) 
  #    - Anything after  ? is true case
  #    - Anything after  : is false case
  #    - Anything after  : is false case
  for_each = var.feature_toggles["storage_account"] ? var.storage_account_config : {}
  source   = "../../modules/storage-account"

  name                = each.value.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  account_tier             = each.value.storage_account_tier
  account_replication_type = each.value.storage_account_replication_type
  account_kind             = each.value.storage_account_kind
  tags                     = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# WEB APP SERVICE CONFIG - VNET INTEGRATION - optional
module "app_service" {
  for_each = var.feature_toggles["app_service"] ? var.app_service_config : {}
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

  depends_on = [module.vnet_qc, module.vnet_sc]
}


# Azure Cache for Redis config
module "redis_cache" {
  for_each = var.feature_toggles["redis"] ? var.redis_config : {}
  source   = "../../modules/cache-for-redis"

  name                = each.value.name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku_name            = each.value.sku_name
  capacity            = each.value.capacity
  family              = each.value.family
  minimum_tls_version = "1.2"

  shard_count         = each.value.shard_count
  replicas_per_master = each.value.replicas_per_master

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}


# FUNCTION APP CONFIG
module "function_app" {
  for_each = var.feature_toggles["function_app"] ? var.function_app_config : {}
  source   = "../../modules/function-app-container"

  function_name  = each.value.name
  func_plan_name = "asp-${each.value.name}"

  location            = each.value.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  func_os_type = var.function_app_config["fa_1"].os_type
  func_sku = var.function_app_config["fa_1"].sku
  func_zone_balancing = var.function_app_config["fa_1"].zone_balancing

  func_storage_account_name     = var.function_app_config["fa_1"].storage_account_name
  func_storage_account_tier     = var.function_app_config["fa_1"].storage_account_tier
  func_account_replication_type = var.function_app_config["fa_1"].account_replication_type
  func_account_kind             = var.function_app_config["fa_1"].account_kind

  func_image_name   = var.function_app_config["fa_1"].image_name
  func_image_tag    = var.function_app_config["fa_1"].image_tag
  func_registry_url = var.function_app_config["fa_1"].registry_url

  vnet_subnet_id = local.subnets[each.value.subnet_key]
  tags           = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc, module.storage_account]
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

  depends_on = [module.vnet_qc, module.vnet_sc]
}


# Azure API Management
module "apim" {
  for_each = var.feature_toggles["apim"] ? var.apim_config : {}
  source   = "../../modules/apim"

  name                = each.value.name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  publisher_name  = each.value.publisher_name
  publisher_email = each.value.publisher_email
  sku_name        = each.value.sku_name

  depends_on = [module.vnet_qc, module.vnet_sc, module.service_bus]
}

# Azure Service Bus
module "service_bus" {
  for_each = var.feature_toggles["service_bus"] ? var.service_bus_config : {}
  source   = "../../modules/service-bus"

  name                         = each.value.name
  location                     = data.azurerm_resource_group.rg_dev.location
  resource_group_name          = data.azurerm_resource_group.rg_dev.name
  capacity                     = each.value.capacity
  sbus_sku_name                = each.value.sku_name
  premium_messaging_partitions = each.value.premium_messaging_partitions

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# Azure Cosmos DB
module "cosmos_db" {
  for_each = var.feature_toggles["cosmos_db"] ? var.cosmos_db_config : {}
  source   = "../../modules/cosmos-db"

  name                            = each.value.name
  resource_group_name             = data.azurerm_resource_group.rg_dev.name
  location                        = each.value.location
  throughput                      = each.value.throughput
  zone_redundant                  = each.value.zone_redundant
  db_name                         = each.value.database_name
  enable_multiple_write_locations = each.value.enable_multiple_write_locations
  cosmos_db_offer_type            = each.value.offer_type
  cosmos_db_kind                  = each.value.kind
  cosmos_db_free_tier_enabled     = each.value.free_tier_enabled
  backup_type                     = each.value.backup_type
  backup_interval_in_minutes      = each.value.backup_interval_in_minutes
  backup_retention_in_hours       = each.value.backup_retention_in_hours
  backup_storage_redundancy       = each.value.backup_storage_redundancy

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# Azure PostgreSQL Flexible Server
module "postgresql" {
  for_each = var.feature_toggles["postgresql"] ? nonsensitive(var.postgresql_config) : {}
  source   = "../../modules/postgresql"

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  administrator_login    = each.value.administrator_login
  administrator_password = each.value.administrator_password
  sku_name               = each.value.sku_name
  storage_mb             = each.value.storage_mb

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# Azure Event Grid Namespace
module "event_grid" {
  for_each = var.feature_toggles["event_grid"] ? var.event_grid_config : {}
  source   = "../../modules/event-grid"

  name                = each.value.name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku      = each.value.sku
  capacity = each.value.capacity

  public_network_access_enabled = each.value.public_network_access_enabled

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# Azure Logic App Standard
module "logic_app" {
  for_each = var.feature_toggles["logic_app"] ? var.logic_app_config : {}
  source   = "../../modules/logic-app"

  name                = each.value.name
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  app_service_plan_name            = "asp-${each.value.name}"
  sku_name                         = each.value.sku_name
  zone_balancing_enabled           = each.value.zone_balancing_enabled
  storage_account_name             = each.value.storage_account_name
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  virtual_network_subnet_id        = module.subnet_logic_sc.subnet_id

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc, module.storage_account]
}

# Azure Event Hub Namespace
module "event_hub" {
  for_each = var.feature_toggles["event_hub"] ? var.event_hub_config : {}
  source   = "../../modules/event-hub"

  name                = each.value.name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  sku      = each.value.sku
  capacity = each.value.capacity

  public_network_access_enabled = each.value.public_network_access_enabled

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}

# Azure Linux Virtual Machine
module "linux_vm" {
  for_each = var.feature_toggles["vm_linux"] ? nonsensitive(var.vm_linux_config) : {}
  source   = "../../modules/linux-vm"

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = data.azurerm_resource_group.rg_dev.location

  size           = each.value.size
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  subnet_id = local.subnets[each.value.subnet_key] # e.g "pep_qc" check out local.subnets in vnet.tf file

  source_image = each.value.source_image

  tags = local.common_tags

  depends_on = [module.vnet_qc, module.vnet_sc]
}
