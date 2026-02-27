resource "azurerm_service_plan" "this" {
  name                = var.func_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.func_os_type

  sku_name = var.func_sku   # Premium Elastic Plan 1

  zone_balancing_enabled = var.func_zone_balancing
}

resource "azurerm_storage_account" "this" {
  name                     = var.func_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = var.func_storage_account_tier
  account_replication_type = var.func_account_replication_type
  account_kind             = var.func_account_kind

  access_tier = "Hot"

  public_network_access_enabled = false
  shared_access_key_enabled     = true

  min_tls_version = "TLS1_2"
}
resource "azurerm_storage_share" "this" {
  name                 = "function-content"
  storage_account_id = azurerm_storage_account.this.id
  quota                = 50
}

resource "azurerm_linux_function_app" "this" {
  name                       = var.function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.this.id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key

  https_only = true

  public_network_access_enabled = false

  site_config {
    application_stack {
      docker {
        image_tag = var.func_image_tag
        image_name   = var.func_image_name
        registry_url = var.func_registry_url
      }
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = azurerm_storage_account.this.primary_connection_string
    WEBSITE_CONTENTSHARE = azurerm_storage_share.this.name
  }
}