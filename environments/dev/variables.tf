# This file DECLARES the variables and their types.
# It acts like a "data contract" for your infrastructure.

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "location2" {
  description = "Second Azure region (Optional)"
  type        = string
  default     = ""
}


# STORAGE ACCOUNT CONFIG
variable "storage_account_name_dev" {
  type = string
}
variable "storage_account_tier" {
  type = string
}
variable "storage_account_replication_type" {
  type = string
}
variable "storage_account_kind" {
  type    = string
  default = "StorageV2"
}

# WEB APP SERVICE CONFIG (Map of Objects)
# 'map(object({}))' allows you to define a list of apps as key-value pairs
# This makes the code scalable—add one app or twenty apps without changing main.tf
variable "app_services_web_app" {
  description = "A map of app services to deploy"
  type = map(object({
    name           = string
    sku            = string
    zone_balancing = bool
    docker_image   = string
  }))
}

# FUNCTION APP CONFIG (Map of Objects)
# Similar to the Web App map, this handles all settings for Function Apps
variable "function_container_premium" {
  description = "A map of function apps to deploy"
  type = map(object({
    name                     = string
    sku                      = string
    os_type                  = string
    zone_balancing           = bool
    storage_account_name     = string
    storage_account_tier     = string
    account_replication_type = string
    account_kind             = string
    image_name               = string
    image_tag                = string
    registry_url             = string
  }))
}


# AZURE KEY VAULT CONFIG
variable "key_vault_name" {
  type = string
}

# AZURE API MANAGEMENT CONFIG
variable "apim_name" {
  type = string
}
variable "apim_publisher_name" {
  type = string
}
variable "apim_publisher_email" {
  type = string
}
variable "sku_name" {
  type = string
}

# AZURE SERVICE BUS CONFIG
variable "service_bus_name" {
  type = string
}
variable "service_bus_capacity" {
  type = number
}
variable "sbus_sku_name" {
  type = string
}
variable "premium_messaging_partitions" {
  type = number
}

# AZURE COSMOS DB CONFIG
variable "cosmos_db_name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "cosmos_db_throughput" {
  description = "Cosmos DB manual throughput"
  type        = number
  default     = 6000
}

variable "cosmos_db_location" {
  description = "Cosmos DB primary location"
  type        = string
  default     = "uaenorth"
}

variable "cosmos_db_zone_redundant" {
  description = "Enable zone redundant"
  type        = bool
  default     = false
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

variable "cosmos_db_enable_multiple_write_locations" {
  description = "Enable multiple write locations"
  type        = bool
  default     = false
}

variable "cosmos_db_database_name" {
  description = "Cosmos DB database name"
  type        = string
}
