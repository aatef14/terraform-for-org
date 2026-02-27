variable "name" {
  description = "Storage account name"
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
variable "account_tier" {
  type        = string
  description = "Storage account tier"
}

variable "account_replication_type" {
  type        = string
  description = "Replication type"
}

variable "account_kind" {
  type        = string
  description = "Storage account kind"
}
