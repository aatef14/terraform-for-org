# Private Endpoints for Dev Environment
# This file manages all Private Endpoints for secure service communication

# 1. Private Endpoint for Frontend Web App
module "pe_app_frontend" {
  source = "../../modules/pep"

  name                = "pe-${var.app_service_name_fend}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.app_service_frontend.app_service_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [module.dns_zone_websites.dns_zone_id]

  tags = local.common_tags
}

# 2. Private Endpoint for Backend Web App
module "pe_app_backend" {
  source = "../../modules/pep"

  name                = "pe-${var.app_service_name_bend}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.app_service_backend.app_service_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [module.dns_zone_websites.dns_zone_id]

  tags = local.common_tags
}

# 3. Private Endpoint for Storage Account (Blob)
module "pe_storage_blob" {
  count  = var.enable_storage_account ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.storage_account_name_dev}-blob"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.storage_account[0].storage_account_id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [module.dns_zone_blob.dns_zone_id]

  tags = local.common_tags
}

# 4. Private Endpoint for Storage Account (File Share)
module "pe_storage_file" {
  count  = var.enable_storage_account ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.storage_account_name_dev}-file"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.storage_account[0].storage_account_id
  subresource_names              = ["file"]
  private_dns_zone_ids           = [module.dns_zone_file.dns_zone_id]

  tags = local.common_tags
}

# 5. Private Endpoint for Key Vault
module "pe_keyvault" {
  count  = var.enable_key_vault ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.key_vault_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.key_vault[0].key_vault_id
  subresource_names              = ["vault"]
  private_dns_zone_ids           = [module.dns_zone_keyvault.dns_zone_id]

  tags = local.common_tags
}

# 6. Private Endpoint for Redis Cache
module "pe_redis" {
  count  = var.enable_redis ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.redis_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.redis_cache[0].redis_id
  subresource_names              = ["redisCache"]
  private_dns_zone_ids           = [module.dns_zone_redis[0].dns_zone_id]

  tags = local.common_tags
}


# sweden central
# 7. Private Endpoint for Service Bus
module "pe_service_bus" {
  count  = var.enable_service_bus ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.service_bus_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.service_bus[0].namespace_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [module.dns_zone_messaging[0].dns_zone_id]

  tags = local.common_tags
}

# 8. Private Endpoint for API Management
module "pe_apim" {
  count  = var.enable_apim ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.apim_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.apim[0].apim_id
  subresource_names              = ["Gateway"]
  private_dns_zone_ids           = [module.dns_zone_apim[0].dns_zone_id]

  tags = local.common_tags
}


# 9. Private Endpoint for PostgreSQL
module "pe_postgresql" {
  count  = var.enable_postgresql ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.postgresql_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.postgresql[0].postgresql_id
  subresource_names              = ["postgresqlServer"]
  private_dns_zone_ids           = [module.dns_zone_postgresql[0].dns_zone_id]

  tags = local.common_tags
}

# 10. Private Endpoint for Cosmos DB
# Note: Cosmos DB module is currently commented out in main.tf
# Uncomment when cosmos_db module is enabled
# module "pe_cosmos_db" {
#   count  = var.enable_cosmos_db ? 1 : 0
#   source = "../../modules/pep"
#
#   name                = "pe-${var.cosmos_db_name}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   subnet_id           = module.subnet_pep_qc.subnet_id
#
#   private_connection_resource_id = module.cosmos_db[0].cosmos_db_id
#   subresource_names              = ["Sql"]
#   private_dns_zone_ids           = [module.dns_zone_cosmos_db[0].dns_zone_id]
#
#   tags = local.common_tags
# }


# sweden central
# 11. Private Endpoint for Event Grid
module "pe_event_grid" {
  count  = var.enable_event_grid ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.event_grid_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.event_grid[0].eventgrid_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [module.dns_zone_eventgrid.dns_zone_id]

  tags = local.common_tags
}


# sweden central
# 12. Private Endpoint for Logic App Standard 
module "pe_logic_app" {
  count  = var.enable_logic_app ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.logic_app_name}"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.logic_app[0].logic_app_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [module.dns_zone_websites.dns_zone_id]

  tags = local.common_tags
}

# 13. Private Endpoint for Event Hub Namespace
module "pe_event_hub" {
  count  = var.enable_event_hub ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.event_hub_name}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.event_hub[0].eventhub_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [module.dns_zone_messaging[0].dns_zone_id]

  tags = local.common_tags
}

# 14. Private Endpoint for Function App (sweden central)
module "pe_function_app" {
  count  = var.enable_function_app ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-func-container-premium"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app_1[0].function_app_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [module.dns_zone_websites.dns_zone_id]

  tags = local.common_tags
}

# 15. Private Endpoint for Function App Storage (Blob)
module "pe_func_storage_blob" {
  count  = var.enable_function_app ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-stfuncqeqispstg01-blob"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app_1[0].storage_account_id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [module.dns_zone_blob.dns_zone_id]

  tags = local.common_tags
}

# 16. Private Endpoint for Function App Storage (File)
module "pe_func_storage_file" {
  count  = var.enable_function_app ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-stfuncqeqispstg01-file"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app_1[0].storage_account_id
  subresource_names              = ["file"]
  private_dns_zone_ids           = [module.dns_zone_file.dns_zone_id]

  tags = local.common_tags
}
