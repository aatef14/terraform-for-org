# Web App service plan
resource "azurerm_service_plan" "this" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = var.sku_name

  zone_balancing_enabled = var.zone_balancing_enabled
}

# App Service web app 
resource "azurerm_linux_web_app" "this" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  https_only                    = true
  public_network_access_enabled = false

  site_config {
    always_on           = true
    minimum_tls_version = "1.2"

    application_stack {
      docker_image_name = var.docker_image_name
    }
  }
}

