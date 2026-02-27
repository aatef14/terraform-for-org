output "app_service_id" {
  value = azurerm_linux_web_app.this.id
}

output "app_service_plan_id" {
  value = azurerm_service_plan.this.id
}
