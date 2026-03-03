resource "azurerm_eventhub_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}
