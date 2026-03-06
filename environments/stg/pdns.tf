# Private DNS Zones for Dev Environment
# Manage all DNS zones using one reusable module

# For more information check github.com/aatef14/terraform-for-org/more-info/pdns.md

locals {
  private_dns_zones = {
    websites   = "privatelink.azurewebsites.net"
    blob       = "privatelink.blob.core.windows.net"
    file       = "privatelink.file.core.windows.net"
    keyvault   = "privatelink.vaultcore.azure.net"
    eventgrid  = "privatelink.eventgrid.azure.net"
    apim       = var.feature_toggles["apim"] ? "privatelink.azure-api.net" : null
    messaging  = var.feature_toggles["service_bus"] ? "privatelink.servicebus.windows.net" : null
    postgresql = var.feature_toggles["postgresql"] ? "privatelink.postgres.database.azure.com" : null
    redis      = var.feature_toggles["redis"] ? "privatelink.redis.cache.windows.net" : null
    search     = var.enable_ai_search ? "privatelink.search.windows.net" : null
    openai     = var.enable_openai ? "privatelink.openai.azure.com" : null
    aiservices = var.enable_ai_foundry ? "privatelink.services.ai.azure.com" : null
    # If you want to add more private DNS zones, add them here e.g
    #  service = "privatelink.servicebus.windows.net"
  }

  # Remove zones that are disabled (null)
  filtered_dns_zones = {
    for k, v in local.private_dns_zones : k => v if v != null
    # Code Explanation:
    # 1. for k, v in local.private_dns_zones : k => v if v != null
    #    - This is a for expression that iterates over the private_dns_zones map
    #    - k is the key (e.g. "websites")
    #    - v is the value (e.g. "privatelink.azurewebsites.net")
    #    - if v != null means it will only include the key-value pairs where the value is not null
    # 2. filtered_dns_zones is a map that contains only the private DNS zones that are enabled
    #    - e.g. { websites = "privatelink.azurewebsites.net" }
  }
}

module "dns_zones" {
  source   = "../../modules/pdns"
  for_each = local.filtered_dns_zones

  dns_zone_name       = each.value
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = { # You can add more vnet links here e.g "link-nc" = module.vnet_nc.vnet_id
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}