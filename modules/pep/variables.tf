variable "name" {
  description = "Name of the private endpoint"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to place the private endpoint in"
  type        = string
}

variable "private_connection_resource_id" {
  description = "The ID of the resource to connect to"
  type        = string
}

variable "subresource_names" {
  description = "A list of sub-resource names which the Private Endpoint is able to connect to"
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require manual approval from the remote resource owner?"
  type        = bool
  default     = false
}

variable "private_dns_zone_ids" {
  description = "A list of Private DNS Zone IDs to associate with the Private Endpoint"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
