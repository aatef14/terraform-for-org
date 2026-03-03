variable "name" {
  description = "The name of the PostgreSQL Flexible Server"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "administrator_login" {
  description = "The administrator login name"
  type        = string
}

variable "administrator_password" {
  description = "The administrator password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL Flexible Server (e.g., GP_Standard_D2ds_v5)"
  type        = string
  default     = "GP_Standard_D2ds_v5"
}

variable "storage_mb" {
  description = "The storage capacity in MB (e.g., 131072 for 128 GiB)"
  type        = number
  default     = 131072
}

variable "server_version" {
  description = "PostgreSQL version (11, 12, 13, 14, 15, 16)"
  type        = string
  default     = "16"
}

variable "delegated_subnet_id" {
  description = "The ID of the subnet for VNet integration"
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
