# Azure Key Vault
resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  # Access Policy permission model (default)
  # No access_policy block included

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled = false
}
