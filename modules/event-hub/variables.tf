variable "name" {
  description = "Name of the Event Hub Namespace"
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

variable "sku" {
  description = "Defines which tier to use. Valid options are Basic, Standard, and Premium."
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
  type        = number
  default     = 1
}

variable "public_network_access_enabled" {
  description = "Is public network access enabled?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
