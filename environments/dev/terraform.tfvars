# This file provides the ACTUAL VALUES for the variables.
# It is the only file you usually need to change when adding or removing apps.

# Provider Authentication
subscription_id     = "sub-id-here"
resource_group_name = "env-wise-resourceGroup"
location            = "eastus"
location2           = ""

# MODULE TOGGLES (Set to false to prevent creation)
enable_storage_account = false
enable_key_vault       = false
enable_apim            = false
enable_service_bus     = false
enable_cosmos_db       = false
enable_redis           = false
enable_postgresql      = false
enable_event_grid      = false
enable_logic_app       = false
enable_event_hub       = false
enable_vm_linux        = false
enable_function_app    = false

# AI FEATURE TOGGLES
enable_ai_foundry = false
enable_ai_search  = false
enable_openai     = false


# Storage Account Details
storage_account_name_dev         = "storage-account"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"

# Azure Web app config
# FrontEnd
app_service_name_fend        = "app-1"
sku_name_fend                = "value"
zoone_balancing_enabled_fend = false
docker_image_name_fend       = "value"

# Backend
app_service_name_bend        = "app-2"
sku_name_bend                = "value"
zoone_balancing_enabled_bend = false
docker_image_name_bend       = "value"

# Azure Function config
func_image_name = "value"


# Redis Cache Config
redis_name        = "azure-cache-for-redis"
redis_sku         = "Premium"
redis_capacity    = 1
redis_family      = "P"
redis_shard_count = 1

# Azure Key Vault Config
key_vault_name     = "key-cault"
key_vault_sku_name = "standard"


# Azure APIM config
apim_name            = "azure-apim"
apim_publisher_name  = "Qatar Energy Dev"
apim_publisher_email = "your-email@company.com"
sku_name             = "Basic_1"

# Postgresql config
postgresql_name           = "azure-psql"
postgresql_admin_login    = "psqladmin"
postgresql_admin_password = "Password1234!" # Recommendation: use a random string
postgresql_sku            = "GP_Standard_D2ds_v5"
postgresql_storage_mb     = 131072

# Service Bus namespace config #sweden central
service_bus_name             = "azure-service-bus"
service_bus_capacity         = 0
premium_messaging_partitions = 0
sbus_sku_name                = "Basic"

# Event Grid config #sweden central
event_grid_name                  = "azure-event-grid"
event_grid_sku                   = "Standard"
event_grid_capacity              = 1
event_grid_public_network_access = false

# Event Hub config
event_hub_name                  = "azure-event-hub"
event_hub_sku                   = "Standard"
event_hub_capacity              = 3
event_hub_public_network_access = false

# Logic App Standard config #sweden central
logic_app_name           = "azure-logic-app"
logic_app_plan_name      = "asp-logic-qe-qisp-stg-sc-01"
logic_app_sku            = "WS1"
logic_app_zone_balancing = false
logic_app_storage_name   = "stlogicqeqispstgsc01"

# Linux VM config
vm_linux_name           = "vm-linux"
vm_linux_size           = "Standard_D4s_v4"
vm_linux_admin_username = "azureuser"
vm_linux_admin_password = "Password123!" # Recommendation: Change this immediately




# COSMOS DB NO SQL config
cosmos_db_name                            = "azure-cosmo-nosql"
cosmos_db_throughput                      = 1000
cosmos_db_location                        = "uaenorth"
cosmos_db_kind                            = "GlobalDocumentDB"
cosmos_db_offer_type                      = "Standard"
cosmos_db_free_tier_enabled               = true
cosmos_db_database_name                   = "enterprise_memory"
cosmos_db_zone_redundant                  = false
cosmos_db_enable_multiple_write_locations = false
cosmos_db_backup_type                     = "Periodic"
cosmos_db_backup_storage_redundancy       = "Local"
cosmos_db_backup_interval_in_minutes      = 60
cosmos_db_backup_retention_in_hours       = 0




















# VNET Config
# VNET_Qatar_Central
vnet_name_qc          = "vnet-qe-qisp-stg-qc-01"
vnet_address_space_qc = ["10.0.0.0/24"]
location_qc           = "qatarcentral"

# Subnet private end point qc
subnet_pep_qc_name   = "snet-pep-qe-qisp-dev-qc-01"
subnet_pep_qc_prefix = ["/27"]
# subnet front end qc
subnet_fend_qc_name   = "snet-app-frontend-qe-qisp-stg-qc-01"
subnet_fend_qc_prefix = ["/28"]
# subnet back end qc
subnet_bend_qc_name   = "snet-app-backend-qe-qisp-stg-qc-01"
subnet_bend_qc_prefix = ["/28"]
# subnet apim  qc
subnet_apim_qc_name   = "snet-apim-qe-qisp-stg-qc-01"
subnet_apim_qc_prefix = ["/28"]

# subnet database qc
subnet_db_qc_name   = "snet-db-qe-qisp-stg-qc-01"
subnet_db_qc_prefix = ["/28"]

# subnet vm qc
subnet_vm_qc_name   = "snet-vm-qe-qisp-stg-qc-01"
subnet_vm_qc_prefix = ["/28"]


# VNET_Sweden_Central
vnet_name_sc          = "vnet-dev-qe-01"
vnet_address_space_sc = ["10.0.0.0/16"]
location_sc           = "swedencentral"

# subnet private endpoint sc
subnet_pep_sc_name   = "snet-pep-qe-qisp-stg-sc-01"
subnet_pep_sc_prefix = ["/28"]
#subnet logic sc
subnet_logic_sc_name   = "snet-logic-qe-qisp-stg-sc-01"
subnet_logic_sc_prefix = ["/28"]

#subnet function sc
subnet_func_sc_name   = "snet-func-qe-qisp-stg-sc-01"
subnet_func_sc_prefix = ["/28"]


# AI FOUNDRY CONFIG
ai_foundry_hub_name     = "qe-ai-hub"
ai_foundry_project_name = "qe-ai-project"
ai_search_name          = "qe-ai-search"
ai_search_sku           = "standard"
openai_name             = "qe-openai"
openai_sku_name         = "S0"
openai_deployments = {
  "gpt-4o" = {
    model_name    = "gpt-4o"
    model_version = "2024-05-13"
  }
  "text-embedding-3-small" = {
    model_name    = "text-embedding-3-small"
    model_version = "1"
  }
}


