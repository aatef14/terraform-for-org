variable "key_vault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "key_vault_sku_name" {
  type    = string
  default = "standard"
}

variable "tags" {
  type = map(string)
  default = {}
}

