resource "azurerm_ai_foundry_project" "project" {
  name               = var.name
  location           = var.location
  ai_services_hub_id = var.hub_id

  tags = var.tags
}
