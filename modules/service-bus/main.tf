resource "azurerm_servicebus_namespace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = var.sbus_sku_name    #"Premium"
  capacity = var.capacity
  premium_messaging_partitions = var.premium_messaging_partitions
  public_network_access_enabled = false
}
