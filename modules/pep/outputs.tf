output "private_endpoint_id" {
  description = "The ID of the Private Endpoint"
  value       = azurerm_private_endpoint.this.id
}

output "private_endpoint_name" {
  description = "The name of the Private Endpoint"
  value       = azurerm_private_endpoint.this.name
}

output "private_ip_address" {
  description = "The private IP address of the Private Endpoint"
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
