resource "azurerm_eventgrid_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = var.sku
  capacity = var.capacity

  public_network_access = var.public_network_access_enabled ? "Enabled" : "Disabled"

  tags = var.tags
}
