output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip_address" {
  description = "The private IP address of the VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "vm_name" {
  description = "The name of the VM"
  value       = azurerm_linux_virtual_machine.this.name
}
