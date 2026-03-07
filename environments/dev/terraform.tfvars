# This file provides the ACTUAL VALUES for the variables.
# It is the only file you usually need to change when adding or removing apps.

# For more information on skus check github.com/aatef14/terraform-for-org/more-info/sku.md
# For more information on variables check github.com/aatef14/terraform-for-org/more-info/variables.md

# Provider Authentication
subscription_id     = "sub-id-here"
resource_group_name = "env-wise-resourceGroup"
location            = "eastus"
location2           = ""

# MODULE TOGGLES (Set to false to prevent creation)
feature_toggles = {
  storage_account = false
  app_service     = false
  key_vault       = false
  apim            = false
  service_bus     = false
  cosmos_db       = false
  redis           = false
  postgresql      = false
  event_grid      = false
  logic_app       = false
  event_hub       = false
  vm_linux        = false
  function_app    = false
}

# AI FEATURE TOGGLES
enable_ai_foundry = false
enable_ai_search  = false
enable_openai     = false


# Storage Account config
storage_account_config = {
  "st-1" = {
    storage_account_name             = "value"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
    storage_account_kind             = "StorageV2"

  }
}

# Azure Web app config
app_service_config = {
  "fend" = {
    app_service_name       = "app-1"
    sku_name               = "value"
    zone_balancing_enabled = false
    docker_image_name      = "mcr.microsoft.com/appsvc/staticsite"
    location               = "qatarcentral"
    subnet_key             = "fend_qc"
  }
  "bend" = {
    app_service_name       = "app-1"
    sku_name               = "value"
    zone_balancing_enabled = false
    docker_image_name      = "mcr.microsoft.com/appsvc/staticsite"
    location               = "qatarcentral"
    subnet_key             = "bend_qc" # check out local.subnets in vnet.tf file
  }
}


# Azure Function config

function_app_config = {

  function_1 = {
    name                     = "func-container-premium"
    os_type                  = "Linux"
    sku                      = "EP1"
    zone_balancing           = false
    storage_account_name     = "stfuncqeqispstg01"
    storage_account_tier     = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    image_name               = "appsvc/staticsite"
    image_tag                = "latest"
    registry_url             = "https://mcr.microsoft.com"
    location                 = "swedencentral"
    subnet_key               = "func_sc" # check out local.subnets in vnet.tf file 
  }
}


# Redis Cache Config
redis_config = {
  "redis-01" = {
    name                = "azure-cache-for-redis"
    sku_name            = "Premium"
    capacity            = 1
    family              = "P"
    shard_count         = 1
    replicas_per_master = 1
  }
}

# Azure Key Vault Config
key_vault = {
  "kv_1" = {
    key_vault_name = "value"
    key_vault_sku  = "value"

  }
}


# Azure APIM config
apim_config = {
  "apim-01" = {
    name            = "azure-apim"
    publisher_name  = "Qatar Energy Dev"
    publisher_email = "your-email@company.com"
    sku_name        = "Basic_1"
  }
}

# Postgresql config
postgresql_config = {
  "psql-01" = {
    name                   = "azure-psql"
    administrator_login    = "psqladmin"
    administrator_password = "Password1234!" # Recommendation: use a random string
    sku_name               = "GP_Standard_D2ds_v5"
    storage_mb             = 131072
  }
}

# Service Bus namespace config #sweden central
service_bus_config = {
  "sb-01" = {
    name                         = "azure-service-bus"
    capacity                     = 0
    sku_name                     = "Basic"
    premium_messaging_partitions = 0
  }
}

# Event Grid config #sweden central
event_grid_config = {
  "eg-01" = {
    name                          = "azure-event-grid"
    sku                           = "Standard"
    capacity                      = 1
    public_network_access_enabled = false
  }
}

# Event Hub config
event_hub_config = {
  "eh-01" = {
    name                          = "azure-event-hub"
    sku                           = "Standard"
    capacity                      = 3
    public_network_access_enabled = false
  }
}

# Logic App Standard config #sweden central
logic_app_config = {
  "logic-01" = {
    name                   = "azure-logic-app"
    sku_name               = "WS1"
    zone_balancing_enabled = false
    storage_account_name   = "stlogicqeqispstgsc01"
  }
}

# Linux VM config
vm_linux_config = {
  "vm-01" = {
    name           = "vm-dev-linux-01"
    size           = "Standard_D4s_v4"
    admin_username = "azureuser"
    admin_password = "Password123!"
    subnet_id      = "pep_qc" # check out local.subnets in vnet.tf file

    source_image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
}




# COSMOS DB NO SQL config
cosmos_db_config = {
  "cosmos-01" = {
    name                            = "azure-cosmo-nosql"
    throughput                      = 1000
    location                        = "uaenorth"
    kind                            = "GlobalDocumentDB"
    offer_type                      = "Standard"
    free_tier_enabled               = true
    database_name                   = "enterprise_memory"
    zone_redundant                  = false
    enable_multiple_write_locations = false
    backup_type                     = "Periodic"
    backup_storage_redundancy       = "Local"
    backup_interval_in_minutes      = 60
    backup_retention_in_hours       = 0
  }
}






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







# This is managed by VNET>TF AND SUBNET>TF FILE RESPECTIVELY

# # VNET Config
# # VNET_Qatar_Central
# vnet_name_qc          = "vnet-qe-qisp-stg-qc-01"
# vnet_address_space_qc = ["10.0.0.0/24"]
# location_qc           = "qatarcentral"

# # Subnet private end point qc
# subnet_pep_qc_name   = "snet-pep-qe-qisp-dev-qc-01"
# subnet_pep_qc_prefix = ["/27"]
# # subnet front end qc
# subnet_fend_qc_name   = "snet-app-frontend-qe-qisp-stg-qc-01"
# subnet_fend_qc_prefix = ["/28"]
# # subnet back end qc
# subnet_bend_qc_name   = "snet-app-backend-qe-qisp-stg-qc-01"
# subnet_bend_qc_prefix = ["/28"]
# # subnet apim  qc
# subnet_apim_qc_name   = "snet-apim-qe-qisp-stg-qc-01"
# subnet_apim_qc_prefix = ["/28"]

# # subnet database qc
# subnet_db_qc_name   = "snet-db-qe-qisp-stg-qc-01"
# subnet_db_qc_prefix = ["/28"]




# # VNET_Sweden_Central
# vnet_name_sc          = "vnet-dev-qe-01"
# vnet_address_space_sc = ["10.0.0.0/16"]
# location_sc           = "swedencentral"

# # subnet private endpoint sc
# subnet_pep_sc_name   = "snet-pep-qe-qisp-stg-sc-01"
# subnet_pep_sc_prefix = ["/28"]
# #subnet logic sc
# subnet_logic_sc_name   = "snet-logic-qe-qisp-stg-sc-01"
# subnet_logic_sc_prefix = ["/28"]

# #subnet function sc
# subnet_func_sc_name   = "snet-func-qe-qisp-stg-sc-01"
# subnet_func_sc_prefix = ["/28"]