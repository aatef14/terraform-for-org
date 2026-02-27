variable "name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Primary Azure region"
  type        = string
}

variable "zone_redundant" {
  description = "Primary Azure region"
  type        = bool
  default = false
}

variable "cosmos_db_offer_type" {
  description = "Cosmos DB offer type"
  type        = string
  default     = "Standard"
}

variable "cosmos_db_kind" {
  description = "Cosmos DB kind"
  type        = string
  default     = "GlobalDocumentDB"
}

variable "cosmos_db_free_tier_enabled" {
  description = "Enable free tier"
  type        = bool
  default     = false
}

variable "consistency_level" {
  description = "Cosmos DB consistency level"
  type        = string
  default     = "Session"
}

variable "throughput" {
  description = "Manual provisioned throughput (RU/s)"
  type        = number
  default     = 6000
}

variable "enable_multiple_write_locations" {
  description = "Enable multi-region write"
  type        = bool
  default     = false
}

variable "backup_type" {
  description = "Type of backup"
  type        = string
  default     = "Periodic"
}

variable "backup_interval_in_minutes" {
  description = "Backup interval in minutes"
  type        = number
  default     = 240
}

variable "backup_retention_in_hours" {
  description = "Backup retention in hours"
  type        = number
  default     = 8
}

variable "db_name" {
  description = "Name of the Cosmos SQL Database"
  type        = string
}
