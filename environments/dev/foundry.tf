# Configuration for AI Foundry Hub, Project, and associated AI Services

# AI Foundry Hub
module "ai_foundry_hub" {
  count  = var.enable_ai_foundry ? 1 : 0
  source = "../../modules/ai-foundry-hub"

  name                = var.ai_foundry_hub_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name

  storage_account_id = module.storage_account[0].storage_account_id
  key_vault_id       = module.key_vault[0].key_vault_id

  public_network_access_enabled = true

  tags = local.common_tags
}

# AI Foundry Project
module "ai_foundry_project" {
  count  = var.enable_ai_foundry ? 1 : 0
  source = "../../modules/ai-foundry-project"

  name     = var.ai_foundry_project_name
  location = data.azurerm_resource_group.rg_dev.location
  hub_id   = module.ai_foundry_hub[0].hub_id

  tags = local.common_tags
}

# AI Search Service
module "ai_search" {
  count  = var.enable_ai_search ? 1 : 0
  source = "../../modules/ai-search"

  name                = var.ai_search_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  sku                 = var.ai_search_sku

  tags = local.common_tags
}

# OpenAI Cognitive Service
module "openai" {
  count  = var.enable_openai ? 1 : 0
  source = "../../modules/open-ai-cognitive"

  name                = var.openai_name
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  sku_name            = var.openai_sku_name
  deployments         = var.openai_deployments

  tags = local.common_tags
}

# AI FOUNDRY CONNECTIONS
# These modules connect the Hub to the specific AI services

module "hub_connection_openai" {
  count  = (var.enable_ai_foundry && var.enable_openai) ? 1 : 0
  source = "../../modules/ai-foundry-connection"

  name      = "${var.openai_name}-connection"
  hub_id    = module.ai_foundry_hub[0].hub_id
  category  = "AzureOpenAI"
  target    = module.openai[0].openai_endpoint
  auth_type = "ApiKey"
  credentials = {
    key = module.openai[0].primary_key
  }
  metadata = {
    ApiType    = "Azure"
    ResourceId = module.openai[0].openai_id
  }
}

module "hub_connection_search" {
  count  = (var.enable_ai_foundry && var.enable_ai_search) ? 1 : 0
  source = "../../modules/ai-foundry-connection"

  name      = "${var.ai_search_name}-connection"
  hub_id    = module.ai_foundry_hub[0].hub_id
  category  = "CognitiveSearch"
  target    = module.ai_search[0].search_endpoint
  auth_type = "ApiKey"
  credentials = {
    key = module.ai_search[0].primary_key
  }
  metadata = {
    ResourceId = module.ai_search[0].search_id
  }
}

# PRIVATE ENDPOINTS FOR AI SERVICES

# AI Foundry Hub Private Endpoint
module "pe_ai_foundry_hub" {
  count  = var.enable_ai_foundry ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.ai_foundry_hub_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.ai_foundry_hub[0].hub_id
  subresource_names              = ["amlworkspace"]
  private_dns_zone_ids           = [module.dns_zone_aiservices[0].dns_zone_id]

  tags = local.common_tags
}

# AI Search Private Endpoint
module "pe_ai_search" {
  count  = var.enable_ai_search ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.ai_search_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.ai_search[0].search_id
  subresource_names              = ["searchService"]
  private_dns_zone_ids           = [module.dns_zone_search[0].dns_zone_id]

  tags = local.common_tags
}

# OpenAI Private Endpoint
module "pe_openai" {
  count  = var.enable_openai ? 1 : 0
  source = "../../modules/pep"

  name                = "pe-${var.openai_name}"
  location            = data.azurerm_resource_group.rg_dev.location
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  subnet_id           = module.subnet_pep_qc.subnet_id

  private_connection_resource_id = module.openai[0].openai_id
  subresource_names              = ["account"]
  private_dns_zone_ids           = [module.dns_zone_openai[0].dns_zone_id]

  tags = local.common_tags
}
