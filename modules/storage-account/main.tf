resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  access_tier = "Hot"

  public_network_access_enabled = false
  shared_access_key_enabled     = true

  min_tls_version = "TLS1_2"
}