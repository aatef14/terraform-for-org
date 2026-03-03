variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the VM to"
  type        = string
}

variable "size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_D4s_v4"
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  sensitive   = true
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in GB"
  type        = number
  default     = 256
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
