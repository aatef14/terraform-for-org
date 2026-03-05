variable "name" {
  description = "Name of the AI Foundry Hub"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the key vault"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
