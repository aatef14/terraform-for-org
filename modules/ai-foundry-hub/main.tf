resource "azurerm_ai_foundry" "hub" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_id = var.storage_account_id
  key_vault_id       = var.key_vault_id

  public_network_access = var.public_network_access_enabled ? "Enabled" : "Disabled"
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
