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

variable "feature_toggles" {
  type = map(bool)

  default = {
    storage_account = true
    app_service     = true
    key_vault       = true
    apim            = true
    service_bus     = true
    cosmos_db       = true
    redis           = true
    postgresql      = true
    event_grid      = true
    logic_app       = true
    event_hub       = true
    vm_linux        = true
    function_app    = true
  }
}
# AI FEATURE TOGGLES
variable "enable_ai_foundry" {
  type    = bool
  default = false
}
variable "enable_ai_search" {
  type    = bool
  default = false
}
variable "enable_openai" {
  type    = bool
  default = false
}



# STORAGE ACCOUNT CONFIG

variable "storage_account_config" {
  type = map(object({
    storage_account_name             = string
    storage_account_tier             = string
    storage_account_replication_type = string
    storage_account_kind             = string
  }))
}

# App Service - Web app Config

variable "app_service_config" {
  type = map(object({
    app_service_name       = string
    sku_name               = string
    zone_balancing_enabled = bool
    docker_image_name      = optional(string, "mcr.microsoft.com/appsvc/staticsite:latest")
    location               = string
    subnet_key             = string
  }))
}


# Function App - Container Based (Premium)

variable "function_app_config" {
  type = map(object({
    name                 = string
    os_type                  = string
    sku                      = string
    zone_balancing           = bool
    storage_account_name     = string
    storage_account_tier     = string
    account_replication_type = string
    account_kind             = string
    image_name               = string
    image_tag                = string
    registry_url             = string
    location                      = string
    subnet_key                    = string
  }))
}

# REDIS CACHE CONFIG
variable "redis_config" {
  type = map(object({
    name                = string
    sku_name            = string
    capacity            = number
    family              = string
    shard_count         = optional(number)
    replicas_per_master = optional(number)
  }))
}

# KEY VAULT CONFIG

variable "key_vault" {
  type = map(object({
    key_vault_name = string
    key_vault_sku  = optional(string, "Standard")
  }))

}


# AZURE API MANAGEMENT CONFIG
variable "apim_config" {
  type = map(object({
    name            = string
    publisher_name  = string
    publisher_email = string
    sku_name        = string
  }))
}

# AZURE SERVICE BUS CONFIG
variable "service_bus_config" {
  type = map(object({
    name                         = string
    capacity                     = number
    sku_name                     = string
    premium_messaging_partitions = optional(number)
  }))
}

# AZURE COSMOS DB CONFIG
variable "cosmos_db_config" {
  type = map(object({
    name                            = string
    throughput                      = optional(number, 400)
    location                        = string
    zone_redundant                  = optional(bool, false)
    offer_type                      = optional(string, "Standard")
    kind                            = optional(string, "GlobalDocumentDB")
    free_tier_enabled               = optional(bool, false)
    enable_multiple_write_locations = optional(bool, false)
    database_name                   = string
    backup_type                     = optional(string, "Periodic")
    backup_interval_in_minutes      = optional(number, 240)
    backup_retention_in_hours       = optional(number, 8)
    backup_storage_redundancy       = optional(string, "Local")
  }))
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
variable "postgresql_config" {
  type = map(object({
    name                   = string
    administrator_login    = string
    administrator_password = string
    sku_name               = optional(string, "GP_Standard_D2ds_v5")
    storage_mb             = optional(number, 131072)
  }))
  sensitive = true
}

# EVENT GRID CONFIG
variable "event_grid_config" {
  type = map(object({
    name                          = string
    sku                           = optional(string, "Standard")
    capacity                      = optional(number, 1)
    public_network_access_enabled = optional(bool, false)
  }))
}

# EVENT HUB CONFIG
variable "event_hub_config" {
  type = map(object({
    name                          = string
    sku                           = optional(string, "Standard")
    capacity                      = optional(number, 1)
    public_network_access_enabled = optional(bool, false)
  }))
}

# LOGIC APP CONFIG
variable "logic_app_config" {
  type = map(object({
    name                   = string
    sku_name               = optional(string, "WS1")
    zone_balancing_enabled = optional(bool, false)
    storage_account_name   = string
  }))
}

# LINUX VM CONFIG
variable "vm_linux_config" {
  type = map(object({
    name           = string
    size           = string
    admin_username = string
    admin_password = string
    source_image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    subnet_id = optional(string) # if needed
  }))
  sensitive = true
}

# Subnet Function SC
variable "subnet_func_sc_name" {
  type = string
}
variable "subnet_func_sc_prefix" {
  type = list(string)
}
# AI FOUNDRY HUB CONFIG
variable "ai_foundry_hub_name" {
  type = string
}
variable "ai_foundry_project_name" {
  type = string
}

# AI SEARCH CONFIG
variable "ai_search_name" {
  type = string
}
variable "ai_search_sku" {
  type    = string
  default = "standard"
}

# OPENAI CONFIG
variable "openai_name" {
  type = string
}
variable "openai_sku_name" {
  type    = string
  default = "S0"
}
variable "openai_deployments" {
  type = map(object({
    model_name    = string
    model_version = string
  }))
  default = {
    "gpt-4o" = {
      model_name    = "gpt-4o"
      model_version = "2024-05-13"
    }
    "text-embedding-3-small" = {
      model_name    = "text-embedding-3-small"
      model_version = "1"
    }
  }
}
