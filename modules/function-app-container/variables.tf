variable "func_plan_name" {
  type = string
}

variable "func_os_type" {
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

variable "func_account_replication_type" {
  type = string
}

variable "func_account_kind" {
  type = string
}

variable "func_image_name" {
  type    = string
  default = "mcr.microsoft.com/azure-functions/python"
}

variable "func_image_tag" {
  type    = string
  default = "4-python3.11"
}

variable "func_registry_url" {
  type    = string
  default = "https://mcr.microsoft.com"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "vnet_subnet_id" {
  description = "The ID of the subnet for VNet integration"
  type        = string
  default     = null
}
