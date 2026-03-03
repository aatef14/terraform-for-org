output "eventgrid_id" {
  description = "The ID of the Event Grid Namespace"
  value       = azurerm_eventgrid_namespace.this.id
}

output "eventgrid_name" {
  description = "The name of the Event Grid Namespace"
  value       = azurerm_eventgrid_namespace.this.name
}
