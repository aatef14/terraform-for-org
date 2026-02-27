# This file provides the ACTUAL VALUES for the variables.
# It is the only file you usually need to change when adding or removing apps.

# Provider Authentication
subscription_id     = "a2b28c85-1948-4263-90ca-bade2bac4df4"
resource_group_name = "kml_rg_main-4bfdac2cc0a44c62"
location            = "eastus"
location2           = ""

# Storage Account Details
storage_account_name_dev         = "stqeipqispdevqc01"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"

# WEB APP SERVICES
# Add or remove blocks here to scale your apps.
# The 'plan_name' is calculated automatically in main.tf as "asp-<name>"
app_services_web_app = {
  frontend = { # Copy paste this block to add more apps
    name           = "app-frontend-qe-ip-qisp-dev-qc-01"
    sku            = "B1"
    zone_balancing = false
    docker_image   = "mcr.microsoft.com/appsvc/staticsite:latest"
  }
  backend = {
    name           = "app-backend-qe-ip-qisp-dev-qc-01"
    sku            = "B1"
    zone_balancing = false
    docker_image   = "mcr.microsoft.com/appsvc/staticsite:latest"
  }
}

# FUNCTION APP SERVICES (Premium Container Based)
function_container_premium = {
  function_1 = { # Copy paste this block to add more functions
    name                     = "func-container-premium"
    os_type                  = "Linux"
    sku                      = "EP1"
    zone_balancing           = false
    storage_account_name     = "devfuncstorage01"
    storage_account_tier     = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    image_name               = "appsvc/staticsite"
    image_tag                = "latest"
    registry_url             = "https://mcr.microsoft.com"
  }
}

# Azure Key Vault Config
key_vault_name = "kv-dev-qe-01"


# Azure APIM config
apim_name            = "apim-dev-qe-01"
apim_publisher_name  = "Qatar Energy Dev"
apim_publisher_email = "your-email@company.com"
sku_name             = "Basic_1"


# Service Bus namespace config
service_bus_name             = "sb-dev-qe-01"
service_bus_capacity         = 0
premium_messaging_partitions = 0
sbus_sku_name                = "Basic"

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
cosmos_db_backup_type = "Periodic"
cosmos_db_backup_storage_redundancy = "Local"
cosmos_db_backup_interval_in_minutes = 60
cosmos_db_backup_retention_in_hours = 0