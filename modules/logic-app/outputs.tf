output "logic_app_id" {
  description = "The ID of the Logic App Standard"
  value       = azurerm_logic_app_standard.this.id
}

output "logic_app_name" {
  description = "The name of the Logic App Standard"
  value       = azurerm_logic_app_standard.this.name
}

output "logic_app_default_hostname" {
  description = "The default hostname of the Logic App"
  value       = azurerm_logic_app_standard.this.default_hostname
}

output "storage_account_id" {
  description = "The ID of the Logic App storage account"
  value       = azurerm_storage_account.logic.id
}
