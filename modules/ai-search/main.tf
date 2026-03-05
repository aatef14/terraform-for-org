resource "azurerm_search_service" "search" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = var.sku

  replica_count   = var.replica_count
  partition_count = var.partition_count

  semantic_search_sku = var.semantic_search_sku

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}
