# Storage Account required by Logic App Standard
resource "azurerm_storage_account" "logic" {
  name                     = var.storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = var.tags
}

# App Service Plan for Logic App (Workflow Standard)
resource "azurerm_service_plan" "logic" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Windows"
  sku_name = var.sku_name

  tags = var.tags
}

# Logic App Standard
resource "azurerm_logic_app_standard" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.logic.id
  storage_account_name       = azurerm_storage_account.logic.name
  storage_account_access_key = azurerm_storage_account.logic.primary_access_key

  https_only                = true
  virtual_network_subnet_id = var.virtual_network_subnet_id

  site_config {
    always_on                = true
    min_tls_version          = "1.2"
    dotnet_framework_version = "v6.0"
    vnet_route_all_enabled   = true
  }

  tags = var.tags
}
