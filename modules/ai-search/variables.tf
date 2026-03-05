variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "sku" {
  type    = string
  default = "standard"
}
variable "replica_count" {
  type    = number
  default = 1
}
variable "partition_count" {
  type    = number
  default = 1
}
variable "semantic_search_sku" {
  type    = string
  default = "standard"
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
