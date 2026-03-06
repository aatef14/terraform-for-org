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

locals {

  pep_subnets = { # Use this to specify the subnet for each private endpoint 
    qc = module.subnet_pep_qc.subnet_id
    sc = module.subnet_pep_sc.subnet_id
  }

  private_endpoints = { # To add more copy the block and paste it below, and modify the name and other values
    # Frontend Web App  
    frond_end = {
      enabled                        = var.feature_toggles["app_service"]
      name                           = "pep-${var.app_service_config["fend"].app_service_name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc" # Get the subnet ID from the locals.pep_subnets map
      private_connection_resource_id = module.app_service["fend"].app_service_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [local.dns_zone_ids["websites"]]
      tags                           = local.common_tags
    }
    # Backend Web App
    backend_end = {
      enabled                        = var.feature_toggles["app_service"]
      name                           = "pep-${var.app_service_config["bend"].app_service_name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.app_service["bend"].app_service_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [local.dns_zone_ids["websites"]]
      tags                           = local.common_tags
    }
    # Storage Account (Blob)
    storage_blob = {
      enabled                        = var.feature_toggles["storage_account"]
      name                           = "pep-${var.storage_account_config["st-1"].storage_account_name}-blob"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.storage_account["st-1"].storage_account_id
      subresource_names              = ["blob"]
      private_dns_zone_ids           = [local.dns_zone_ids["blob"]]
      tags                           = local.common_tags
    }
    # Storage Account (File)
    storage_file = {
      enabled                        = var.feature_toggles["storage_account"]
      name                           = "pep-${var.storage_account_config["st-1"].storage_account_name}-file"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.storage_account["st-1"].storage_account_id
      subresource_names              = ["file"]
      private_dns_zone_ids           = [local.dns_zone_ids["file"]]
      tags                           = local.common_tags
    }
    # Key Vault
    keyvault = {
      enabled                        = var.feature_toggles["key_vault"]
      name                           = "pep-${var.key_vault["kv_1"].key_vault_name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.key_vault["kv_1"].key_vault_id
      subresource_names              = ["vault"]
      private_dns_zone_ids           = [local.dns_zone_ids["keyvault"]]
      tags                           = local.common_tags
    }
    # Redis Cache
    redis = {
      enabled                        = var.feature_toggles["redis"]
      name                           = "pep-${var.redis_config["redis_1"].name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.redis_cache[0].redis_id
      subresource_names              = ["redisCache"]
      private_dns_zone_ids           = [local.dns_zone_ids["redis"]]
      tags                           = local.common_tags
    }
    # Service Bus
    service_bus = {
      enabled                        = var.feature_toggles["service_bus"]
      name                           = "pep-${var.service_bus_config["sb_1"].name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.service_bus[0].namespace_id
      subresource_names              = ["namespace"]
      private_dns_zone_ids           = [local.dns_zone_ids["messaging"]]
      tags                           = local.common_tags
    }
    # APIM
    apim = {
      enabled                        = var.feature_toggles["apim"]
      name                           = "pep-${var.apim_config["apim_1"].name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.apim[0].apim_id
      subresource_names              = ["apim"]
      private_dns_zone_ids           = [local.dns_zone_ids["apim"]]
      tags                           = local.common_tags
    }
    # Logic App
    logic_app = {
      enabled                        = var.feature_toggles["logic_app"]
      name                           = "pep-${var.logic_app_config["la_1"].name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.logic_app[0].logic_app_id
      subresource_names              = ["logicApp"]
      private_dns_zone_ids           = [local.dns_zone_ids["logicapp"]]
      tags                           = local.common_tags
    }
    # Function App
    function_app = {
      enabled                        = var.feature_toggles["function_app"]
      name                           = "pep-${var.function_app_config["fa_1"].name}"
      location                       = data.azurerm_resource_group.rg_dev.location
      resource_group_name            = data.azurerm_resource_group.rg_dev.name
      subnet                         = "qc"
      private_connection_resource_id = module.function_app[0].function_app_id
      subresource_names              = ["functionApp"]
      private_dns_zone_ids           = [local.dns_zone_ids["functionapp"]]
      tags                           = local.common_tags
    }
  }

  # This block filters the private endpoints that are enabled
  enabled = {
    for k, v in local.private_endpoints : k => v if v.enabled
  }

}


# This block creates the private endpoints - brain
module "private_endpoints" {
  source = "../../modules/pep"

  for_each = local.enabled

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = local.pep_subnets[each.value.subnet]

  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  private_dns_zone_ids           = each.value.private_dns_zone_ids

  tags = local.common_tags
}
