output "function_app_id" {
  description = "The ID of the Function App"
  value       = azurerm_linux_function_app.this.id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = azurerm_linux_function_app.this.name
}

output "storage_account_id" {
  description = "The ID of the Function App storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Function App storage account"
  value       = azurerm_storage_account.this.name
}
