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

# FEATURE TOGGLES
variable "enable_storage_account" {
  type    = bool
  default = true
}
variable "enable_key_vault" {
  type    = bool
  default = true
}
variable "enable_apim" {
  type    = bool
  default = true
}
variable "enable_service_bus" {
  type    = bool
  default = true
}
variable "enable_cosmos_db" {
  type    = bool
  default = true
}
variable "enable_redis" {
  type    = bool
  default = true
}
variable "enable_postgresql" {
  type    = bool
  default = true
}
variable "enable_event_grid" {
  type    = bool
  default = true
}
variable "enable_logic_app" {
  type    = bool
  default = true
}
variable "enable_event_hub" {
  type    = bool
  default = true
}
variable "enable_vm_linux" {
  type    = bool
  default = true
}
variable "enable_function_app" {
  type    = bool
  default = true
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

# App Service - Web app Config
# Frontend
variable "app_service_name_fend" {
  type = string
}
variable "sku_name_fend" {
  type = string
}

variable "zoone_balancing_enabled_fend" {
  type = bool
}

variable "docker_image_name_fend" {
  type = string
}

# Backend
variable "app_service_name_bend" {
  type = string
}
variable "app_service_plan_name_bend" {
  type = string
}

variable "sku_name_bend" {
  type = string
}

variable "zoone_balancing_enabled_bend" {
  type = bool
}

variable "docker_image_name_bend" {
  type    = string
  default = "mcr.microsoft.com/appsvc/staticsite:latest"
}

# Function App - Container Based (Premium)
variable "function_name" {
  type = string
}
variable "func_plan_name" {
  type = string
}
variable "func_os_type" {
  type    = string
  default = "Linux"
}
variable "func_sku" {
  type    = string
  default = "EP1"
}
variable "func_zone_balancing" {
  type    = bool
  default = false
}
variable "func_storage_account_name" {
  type = string
}
variable "func_storage_account_tier" {
  type    = string
  default = "Standard"
}
variable "func_account_replication_type" {
  type    = string
  default = "LRS"
}
variable "func_account_kind" {
  type    = string
  default = "StorageV2"
}
variable "func_image_name" {
  type    = string
  default = "appsvc/staticsite"
}
variable "func_image_tag" {
  type    = string
  default = "latest"
}
variable "func_registry_url" {
  type    = string
  default = "https://mcr.microsoft.com"
}

# REDIS CACHE CONFIG
variable "redis_name" {
  type = string
}
variable "redis_sku" {
  type = string
}
variable "redis_capacity" {
  type = number
}
variable "redis_family" {
  type = string
}
variable "redis_shard_count" {
  type    = number
  default = null
}
variable "redis_replicas_per_master" {
  type    = number
  default = null
}

# KEY VAULT CONFIG
variable "key_vault_name" {
  type = string
}
variable "key_vault_sku_name" {
  type    = string
  default = "standard"
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

variable "cosmos_db_backup_type" {
  description = "Cosmos DB backup type"
  type        = string
  default     = "Periodic"
}

variable "cosmos_db_backup_interval_in_minutes" {
  description = "Cosmos DB backup interval"
  type        = number
  default     = 240
}

variable "cosmos_db_backup_retention_in_hours" {
  description = "Cosmos DB backup retention"
  type        = number
  default     = 8
}

variable "cosmos_db_backup_storage_redundancy" {
  description = "Cosmos DB backup storage redundancy"
  type        = string
  default     = "Geo"
}

variable "cosmos_db_database_name" {
  description = "Cosmos DB database name"
  type        = string
}


# VNET CONFIG
# VNET_Qatar_Central
variable "vnet_name_qc" {
  type        = string
  description = "Name of the virtual network"
}

variable "location_qc" {
  type = string
}

variable "vnet_address_space_qc" {
  type = list(string)
}

# Subnet private end point
variable "subnet_pep_qc_name" {
  type = string
}
variable "subnet_pep_qc_prefix" {
  type = list(string)
}
# Subnet front end
variable "subnet_fend_qc_name" {
  type = string
}
variable "subnet_fend_qc_prefix" {
  type = list(string)
}
# Subnet back end
variable "subnet_bend_qc_name" {
  type = string
}
variable "subnet_bend_qc_prefix" {
  type = list(string)
}
# Subnet api management
variable "subnet_apim_qc_name" {
  type = string
}
variable "subnet_apim_qc_prefix" {
  type = list(string)
}

# Subnet database qc
variable "subnet_db_qc_name" {
  type = string
}
variable "subnet_db_qc_prefix" {
  type = list(string)
}

# VNET_Sweden_Central
variable "vnet_name_sc" {
  type        = string
  description = "Name of the virtual network"
}
variable "location_sc" {
  type = string
}
variable "vnet_address_space_sc" {
  type        = list(string)
  description = "Address space for the VNet"
}

# Subnet private end point
variable "subnet_pep_sc_name" {
  type = string
}
variable "subnet_pep_sc_prefix" {
  type = list(string)
}
# Subnet logic
variable "subnet_logic_sc_name" {
  type = string
}
variable "subnet_logic_sc_prefix" {
  type = list(string)
}

# POSTGRESQL CONFIG
variable "postgresql_name" {
  type = string
}
variable "postgresql_admin_login" {
  type = string
}
variable "postgresql_admin_password" {
  type      = string
  sensitive = true
}
variable "postgresql_sku" {
  type    = string
  default = "GP_Standard_D2ds_v5"
}
variable "postgresql_storage_mb" {
  type    = number
  default = 131072
}

# EVENT GRID CONFIG
variable "event_grid_name" {
  type = string
}
variable "event_grid_sku" {
  type    = string
  default = "Standard"
}
variable "event_grid_capacity" {
  type    = number
  default = 1
}
variable "event_grid_public_network_access" {
  type    = bool
  default = false
}

# EVENT HUB CONFIG
variable "event_hub_name" {
  type = string
}
variable "event_hub_sku" {
  type    = string
  default = "Standard"
}
variable "event_hub_capacity" {
  type    = number
  default = 1
}
variable "event_hub_public_network_access" {
  type    = bool
  default = false
}

# LOGIC APP CONFIG
variable "logic_app_name" {
  type = string
}
variable "logic_app_plan_name" {
  type = string
}
variable "logic_app_sku" {
  type    = string
  default = "WS1"
}
variable "logic_app_zone_balancing" {
  type    = bool
  default = false
}
variable "logic_app_storage_name" {
  type = string
}

# LINUX VM CONFIG
variable "vm_linux_name" {
  type = string
}
variable "vm_linux_size" {
  type    = string
  default = "Standard_D4s_v4"
}
variable "vm_linux_admin_username" {
  type    = string
  default = "azureuser"
}
variable "vm_linux_admin_password" {
  type      = string
  sensitive = true
}

# Subnet VM QC
variable "subnet_vm_qc_name" {
  type = string
}
variable "subnet_vm_qc_prefix" {
  type = list(string)
}

# Subnet Function SC
variable "subnet_func_sc_name" {
  type = string
}
variable "subnet_func_sc_prefix" {
  type = list(string)
}
