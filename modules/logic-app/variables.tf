variable "name" {
  description = "The name of the Logic App Standard"
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

variable "app_service_plan_name" {
  description = "The name of the App Service Plan for Logic App"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan (WS1, WS2, WS3)"
  type        = string
  default     = "WS1"
}

variable "zone_balancing_enabled" {
  description = "Whether to enable zone balancing"
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "The name of the storage account used by Logic App"
  type        = string
}

variable "storage_account_tier" {
  description = "The tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The replication type of the storage account"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "virtual_network_subnet_id" {
  description = "The ID of the subnet for VNet integration"
  type        = string
  default     = null
}
