# Private Endpoints file.
# This file manages all Private Endpoints for secure service communication

locals { # This is block generates resources IDs for private DNS zones
  dns_zone_ids = {
    for k, v in module.dns_zones : k => v.dns_zone_id
  }
  # Code Explanation:
  # 1. for k, v in module.dns_zones : k => v.dns_zone_id
  #    - This is a for expression that iterates over the dns_zones module inpdns.tf file
  #    - k is the key (e.g. "websites")
  #    - v is the value (e.g. { dns_zone_id = "privatelink.azurewebsites.net" })
  #    - k => v.dns_zone_id means it will create a map where the key is the DNS zone name and the value is the DNS zone ID
  # 2. dns_zone_ids is a map that contains the DNS zone IDs for all enabled DNS zones
}

# Possible entry in private_dns_zones_ids
# private_dns_zone_ids = [local.dns_zone_ids["websites"]]

# 1. Private Endpoint for Frontend Web App
module "pe_app_frontend" {
  source = "../../modules/pep"

  name                = "pep-${var.app_service_config["fend"].app_service_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.app_service["fend"].app_service_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [local.dns_zone_ids["websites"]]

  tags = local.common_tags
}

# 2. Private Endpoint for Backend Web App
module "pe_app_backend" {
  source = "../../modules/pep"

  name                = "pep-${var.app_service_config["bend"].app_service_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.app_service["bend"].app_service_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [local.dns_zone_ids["websites"]]

  tags = local.common_tags
}

# 3. Private Endpoint for Storage Account (Blob)
module "pe_storage_blob" {
  count  = var.feature_toggles["storage_account"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.storage_account_config["st-1"].storage_account_name}-blob"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.storage_account["st-1"].storage_account_id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [local.dns_zone_ids["blob"]]

  tags = local.common_tags
}

# 4. Private Endpoint for Storage Account (File Share)
module "pe_storage_file" {
  count  = var.feature_toggles["storage_account"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.storage_account_config["st-1"].storage_account_name}-file"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.storage_account["st-1"].storage_account_id
  subresource_names              = ["file"]
  private_dns_zone_ids           = [local.dns_zone_ids["file"]]

  tags = local.common_tags
}

# 5. Private Endpoint for Key Vault
module "pe_keyvault" {
  count  = var.feature_toggles["key_vault"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.key_vault["kv_1"].key_vault_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.key_vault["kv_1"].key_vault_id
  subresource_names              = ["vault"]
  private_dns_zone_ids           = [local.dns_zone_ids["keyvault"]]

  tags = local.common_tags
}

# 6. Private Endpoint for Redis Cache
module "pe_redis" {
  count  = var.feature_toggles["redis"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.redis_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.redis_cache[0].redis_id
  subresource_names              = ["redisCache"]
  private_dns_zone_ids           = [local.dns_zone_ids["redis"]]

  tags = local.common_tags
}


# sweden central
# 7. Private Endpoint for Service Bus
module "pe_service_bus" {
  count  = var.feature_toggles["service_bus"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.service_bus_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.service_bus[0].namespace_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [local.dns_zone_ids["messaging"]]

  tags = local.common_tags
}

# 8. Private Endpoint for API Management
module "pe_apim" {
  count  = var.feature_toggles["apim"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.apim_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.apim[0].apim_id
  subresource_names              = ["Gateway"]
  private_dns_zone_ids           = [local.dns_zone_ids["apim"]]

  tags = local.common_tags
}


# 9. Private Endpoint for PostgreSQL
module "pe_postgresql" {
  count  = var.feature_toggles["postgresql"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.postgresql_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.postgresql[0].postgresql_id
  subresource_names              = ["postgresqlServer"]
  private_dns_zone_ids           = [local.dns_zone_ids["postgresql"]]

  tags = local.common_tags
}

# 10. Private Endpoint for Cosmos DB
module "pe_cosmos_db" {
  count  = var.feature_toggles["cosmos_db"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.cosmos_db_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.cosmos_db[0].cosmos_db_id
  subresource_names              = ["Sql"]
  private_dns_zone_ids           = [local.dns_zone_ids["cosmosdb"]]

  tags = local.common_tags
}


# sweden central
# 11. Private Endpoint for Event Grid
module "pe_event_grid" {
  count  = var.feature_toggles["event_grid"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.event_grid_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.event_grid[0].eventgrid_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [local.dns_zone_ids["eventgrid"]]

  tags = local.common_tags
}


# sweden central
# 12. Private Endpoint for Logic App Standard 
module "pe_logic_app" {
  count  = var.feature_toggles["logic_app"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.logic_app_name}"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.logic_app[0].logic_app_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [local.dns_zone_ids["websites"]]

  tags = local.common_tags
}

# 13. Private Endpoint for Event Hub Namespace
module "pe_event_hub" {
  count  = var.feature_toggles["event_hub"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.event_hub_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.event_hub[0].eventhub_id
  subresource_names              = ["namespace"]
  private_dns_zone_ids           = [local.dns_zone_ids["messaging"]]

  tags = local.common_tags
}

# 14. Private Endpoint for Function App (sweden central)
module "pe_function_app" {
  count  = var.feature_toggles["function_app"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.function_app_config["function_1"].function_name}"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app["function_1"].function_app_id
  subresource_names              = ["sites"]
  private_dns_zone_ids           = [local.dns_zone_ids["websites"]]

  tags = local.common_tags
}

# 15. Private Endpoint for Function App Storage (Blob)
module "pe_func_storage_blob" {
  count  = var.feature_toggles["function_app"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.function_app_config["function_1"].func_storage_account_name}-blob"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app["function_1"].storage_account_id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [local.dns_zone_ids["blob"]]

  tags = local.common_tags
}

# 16. Private Endpoint for Function App Storage (File)
module "pe_func_storage_file" {
  count  = var.feature_toggles["function_app"] ? 1 : 0
  source = "../../modules/pep"

  name                = "pep-${var.function_app_config["function_1"].func_storage_account_name}-file"
  location            = var.location_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_sc.subnet_id

  private_connection_resource_id = module.function_app["function_1"].storage_account_id
  subresource_names              = ["file"]
  private_dns_zone_ids           = [local.dns_zone_ids["file"]]

  tags = local.common_tags
}
