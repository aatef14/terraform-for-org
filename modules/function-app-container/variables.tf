variable "func_plan_name" {
  type = string
}

variable func_os_type {
    type = string
}

variable "func_sku" {
    type = string
  
}

variable "func_zone_balancing" {
    type = bool
  
}

variable "function_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "func_storage_account_name" {
  type = string
}

variable "func_storage_account_tier" {
    type = string
  
}

variable func_account_replication_type {
    type = string
}

variable func_account_kind {
    type = string
}

variable "func_image_name" {
  type        = string
  default     = "mcr.microsoft.com/azure-functions/python"
}

variable "func_image_tag" {
  type        = string
  default     = "4-python3.11"
}

variable "func_registry_url" {
  type        = string
  default     = "https://mcr.microsoft.com"
}