# This file provides the ACTUAL VALUES for the variables.
# It is the only file you usually need to change when adding or removing apps.

# Provider Authentication
subscription_id     = "a2b28c85-1948-4263-90ca-bade2bac4df4"
resource_group_name = "kml_rg_main-4bfdac2cc0a44c62"
location            = "eastus"
location2           = ""

# MODULE TOGGLES (Set to false to prevent creation)
enable_storage_account = true
enable_key_vault       = true
enable_apim            = true
enable_service_bus     = true
enable_cosmos_db       = true
enable_redis           = true
enable_postgresql      = true
enable_event_grid      = true
enable_logic_app       = true


# Storage Account Details
storage_account_name_dev         = "stqeqispstgqc01"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"

# Azure Web app config
# FrontEnd
app_service_name_fend        = "app-frontend-qe-qisp-stg-qc-01"
sku_name_fend                = "value"
zoone_balancing_enabled_fend = false
docker_image_name_fend       = "value"

# Backend
app_service_name_bend        = "app-backend-qe-qisp-stg-qc-01"
sku_name_bend                = "value"
zoone_balancing_enabled_bend = false
docker_image_name_bend       = "value"

# Redis Cache Config
redis_name        = "redis-qe-qisp-stg-qc-01"
redis_sku         = "Premium"
redis_capacity    = 1
redis_family      = "P"
redis_shard_count = 1

# Azure Key Vault Config
key_vault_name = "kv-dev-qe-01"


# Azure APIM config
apim_name            = "apim-dev-qe-01"
apim_publisher_name  = "Qatar Energy Dev"
apim_publisher_email = "your-email@company.com"
sku_name             = "Basic_1"

# Postgresql config
postgresql_name           = "psql-qe-qisp-stg-qc-01"
postgresql_admin_login    = "psqladmin"
postgresql_admin_password = "Password1234!" # Recommendation: use a random string
postgresql_sku            = "GP_Standard_D2ds_v5"
postgresql_storage_mb     = 131072

# Service Bus namespace config #sweden central
service_bus_name             = "sb-dev-qe-01"
service_bus_capacity         = 0
premium_messaging_partitions = 0
sbus_sku_name                = "Basic"

# Event Grid config #sweden central
event_grid_name                  = "evgns-qe-qisp-stg-qc-01"
event_grid_sku                   = "Standard"
event_grid_capacity              = 1
event_grid_public_network_access = false

# Logic App Standard config #sweden central
logic_app_name         = "logic-qe-qisp-stg-sc-01"
logic_app_plan_name    = "asp-logic-qe-qisp-stg-sc-01"
logic_app_sku          = "WS1"
logic_app_storage_name = "stlogicqeqispstgsc01"



# COSMOS DB NO SQL config
cosmos_db_name                            = "cosmos-qe-ip-qisp-dev-01"
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


