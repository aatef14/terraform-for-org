output "openai_id" { value = azurerm_cognitive_account.openai.id }
output "openai_endpoint" { value = azurerm_cognitive_account.openai.endpoint }
output "primary_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}
