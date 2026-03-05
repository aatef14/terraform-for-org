# Private DNS Zones for Dev Environment
# This file manages all DNS zones using the reusable private-dns-zone module

# DNS Zone for Web Apps & Logic Apps (Standard)
module "dns_zone_websites" {
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Storage Account - Blob
module "dns_zone_blob" {
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Storage Account - File Share
module "dns_zone_file" {
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Key Vault
module "dns_zone_keyvault" {
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for API Management
module "dns_zone_apim" {
  count  = var.enable_apim ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.azure-api.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Service Bus & Event Hub
module "dns_zone_messaging" {
  count  = var.enable_service_bus ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.servicebus.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for PostgreSQL Flexible Server
module "dns_zone_postgresql" {
  count  = var.enable_postgresql ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.postgres.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Redis Cache
module "dns_zone_redis" {
  count  = var.enable_redis ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.redis.cache.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for Event Grid
module "dns_zone_eventgrid" {
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.eventgrid.azure.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for AI Search Service
module "dns_zone_search" {
  count  = var.enable_ai_search ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.search.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for OpenAI Service
module "dns_zone_openai" {
  count  = var.enable_openai ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.openai.azure.com"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}

# DNS Zone for AI Foundry / AIServices (Global API and Portal access)
module "dns_zone_aiservices" {
  count  = var.enable_ai_foundry ? 1 : 0
  source = "../../modules/pdns"

  dns_zone_name       = "privatelink.services.ai.azure.com"
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  vnet_links = {
    "link-qc" = module.vnet_qc.vnet_id
    "link-sc" = module.vnet_sc.vnet_id
  }

  tags = local.common_tags
}
