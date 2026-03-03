variable "name" {
  description = "The name of the Event Grid Namespace"
  type        = string
}

variable "location" {
  description = "The Azure region where the Event Grid Namespace should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku" {
  description = "The SKU name of the Event Grid Namespace"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "The throughput units for the Event Grid Namespace"
  type        = number
  default     = 1
}

variable "public_network_access_enabled" {
  description = "Is public network access enabled for this Event Grid Namespace?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
