variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "sku_name" {
  type    = string
  default = "S0"
}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "deployments" {
  type = map(object({
    model_name    = string
    model_version = string
  }))
  default = {}
}
