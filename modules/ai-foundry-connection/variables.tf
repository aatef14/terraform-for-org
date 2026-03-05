variable "name" { type = string }
variable "hub_id" { type = string }
variable "category" {
  type        = string
  description = "Category of the connection (AIServices, AzureOpenAI, CognitiveSearch, etc.)"
}
variable "target" {
  type        = string
  description = "The target resource ID or endpoint"
}
variable "auth_type" {
  type    = string
  default = "ApiKey"
}
variable "credentials" {
  type      = any
  sensitive = true
}
variable "is_shared" {
  type    = bool
  default = true
}
variable "metadata" {
  type    = map(string)
  default = {}
}
