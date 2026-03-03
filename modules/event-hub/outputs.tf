output "eventhub_id" {
  description = "The ID of the Event Hub Namespace"
  value       = azurerm_eventhub_namespace.this.id
}

output "eventhub_name" {
  description = "The name of the Event Hub Namespace"
  value       = azurerm_eventhub_namespace.this.name
}

output "eventhub_default_primary_connection_string" {
  description = "The primary connection string for the Event Hub Namespace"
  value       = azurerm_eventhub_namespace.this.default_primary_connection_string
  sensitive   = true
}
