variable "name" {
  description = "Name of the Redis Cache"
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

variable "sku_name" {
  description = "Redis SKU name (Standard, Premium, Basic)"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Redis capacity / instance size (C0–C6, e.g., C3)"
  type        = number
  default     = 1
}

variable "enable_non_ssl_port" {
  description = "Enable non-SSL port (true/false)"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version (e.g., 1.2)"
  type        = string
  default     = "1.2"
}

variable "redis_configuration" {
  description = "Optional Redis configuration map"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}
variable "family" {
  description = "Redis family (C=Standard, P=Premium, B=Basic)"
  type        = string
  default     = "C"
}

variable "shard_count" {
  description = "The number of Shards to create on the Redis Cluster. Only available for Premium SKU."
  type        = number
  default     = null
}

variable "replicas_per_master" {
  description = "The number of replicas to create per master. Only available for Premium SKU."
  type        = number
  default     = null
}
