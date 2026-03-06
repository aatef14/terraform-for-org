variable "name" {
  type        = string
  description = "VM name"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "size" {
  type    = string
  default = "Standard_D4s_v4"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "subnet_id" {
  type = string
}

variable "os_disk_storage_account_type" {
  type    = string
  default = "Premium_LRS"
}

variable "os_disk_size_gb" {
  type    = number
  default = 128
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "source_image" {

  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  description = "VM source image configuration"

  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}