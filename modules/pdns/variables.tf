variable "dns_zone_name" {
  description = "The name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_links" {
  description = "A map of VNet IDs to link to the DNS zone"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
