# This is the Heart of Specific Environment configuration.
# Use this to disable provisioning any unwanted services by selecting the module block 
# and doing Ctrl + /, which will comment out the code.

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Local variables for common settings
# locals are useful for values you want to reuse multiple times in this file
locals {
  common_tags = {
    Environment = "dev"
  }
}

# Storage account config
module "storage_account" {
  source = "../../modules/storage-account"

  name                = var.storage_account_name_dev
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

# WEB APP SERVICE CONFIG
# 'for_each' loops through the map defined in variables.tf (app_services_web_app)
# 'each.key' would be the label (e.g., "frontend")
# 'each.value' contains the technical details (name, sku, etc.)
module "app_services" {
  for_each = var.app_services_web_app
  source   = "../../modules/app-service"

  app_service_name = each.value.name

  # AUTO-GENERATION: Consistently prefix the app name with "asp-" for the Plan name
  app_service_plan_name = "asp-${each.value.name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku_name               = each.value.sku
  zone_balancing_enabled = each.value.zone_balancing
  docker_image_name      = each.value.docker_image
}


# FUNCTION APP CONFIG (Container Based - Premium)
# This also uses 'for_each' to allow deploying multiple functions easily
module "function_app" {
  for_each = var.function_container_premium
  source   = "../../modules/function-app-container"

  function_name = each.value.name

  # AUTO-GENERATION: Consistently prefix the function name with "asp-" for its Plan
  func_plan_name = "asp-${each.value.name}"

  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  func_os_type        = each.value.os_type
  func_sku            = each.value.sku
  func_zone_balancing = each.value.zone_balancing

  func_storage_account_name     = each.value.storage_account_name
  func_storage_account_tier     = each.value.storage_account_tier
  func_account_replication_type = each.value.account_replication_type
  func_account_kind             = each.value.account_kind

  func_image_name   = each.value.image_name
  func_image_tag    = each.value.image_tag
  func_registry_url = each.value.registry_url
}


# Azure Key Vault
data "azurerm_client_config" "current" {}

module "key_vault" {
  source = "../../modules/key-vault"

  key_vault_name      = var.key_vault_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}


# Azure API Management
module "apim" {
  source = "../../modules/apim"

  name                = var.apim_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  publisher_name  = var.apim_publisher_name
  publisher_email = var.apim_publisher_email
  sku_name        = var.sku_name
}

# Azure Service Bus
module "service_bus" {
  source = "../../modules/service-bus"

  name                         = var.service_bus_name
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  capacity                     = var.service_bus_capacity
  sbus_sku_name                = var.sbus_sku_name
  premium_messaging_partitions = var.premium_messaging_partitions
}

# Azure Cosmos DB
module "cosmos_db" {
  source = "../../modules/cosmos-db"

  name                = var.cosmos_db_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.cosmos_db_location
  throughput          = var.cosmos_db_throughput
  zone_redundant      = var.cosmos_db_zone_redundant
  db_name             = var.cosmos_db_database_name
  enable_multiple_write_locations = var.cosmos_db_enable_multiple_write_locations
  cosmos_db_offer_type = var.cosmos_db_offer_type
  cosmos_db_kind = var.cosmos_db_kind
  cosmos_db_free_tier_enabled = var.cosmos_db_free_tier_enabled
}
  