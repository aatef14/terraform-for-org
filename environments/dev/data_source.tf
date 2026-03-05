
# This is a data source file.
# It is used to get the data from the existing Azure resources.
# Modify the values in the file to match the existing Azure resources.
# This file cotaines data sources for resourcee groups and private dns zones and vnets.


# Resource Group Data Sources
data "azurerm_resource_group" "rg_dev" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "rg_test" {
  name = var.resource_group_name # In a real scenario, this would likely be a different variable
}

data "azurerm_resource_group" "rg_prod" {
  name = var.resource_group_name # In a real scenario, this would likely be a different variable
}

# Private DNS  Data Sources
data "azurerm_private_dns_zone" "dns_zone_websites" { # For Web Apps and Logic Apps
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_blob" { # For Storage Accounts
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_file" { # For Storage Accounts
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_apim" { # For API Management
  name                = "privatelink.azure-api.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_messaging" { # For Service Bus and Event Hubs
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_postgresql" { # For PostgreSQL
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_redis" { # For Redis Cache
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_eventgrid" { # For Event Grid
  name                = "privatelink.eventgrid.azure.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_cosmos_db" { # For Cosmos DB
  name                = "privatelink.documents.azure.com"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_search" { # For AI Search
  name                = "privatelink.search.windows.net"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_openai" { # For OpenAI
  name                = "privatelink.openai.azure.com"
  resource_group_name = "privatednszone-rg"
}

data "azurerm_private_dns_zone" "dns_zone_aiservices" { # For AI Foundry / AIServices
  name                = "privatelink.services.ai.azure.com"
  resource_group_name = "privatednszone-rg"
}



# VNET Data Sources - Dev Environment
data "azurerm_virtual_network" "vnet_dev_qc" {
  name                = "vnet-qc"
  resource_group_name = "network-rg"
}

data "azurerm_virtual_network" "vnet_dev_sc" {
  name                = "vnet-sc"
  resource_group_name = "network-rg"
}


# VNET Data Sources - Test Environment
data "azurerm_virtual_network" "vnet_test_qc" {
  name                = "vnet-qc"
  resource_group_name = "network-rg"
}

data "azurerm_virtual_network" "vnet_test_sc" {
  name                = "vnet-sc"
  resource_group_name = "network-rg"
}


# VNET Data Sources - Prod Environment
data "azurerm_virtual_network" "vnet_prod_qc" {
  name                = "vnet-qc"
  resource_group_name = "network-rg"
}

data "azurerm_virtual_network" "vnet_prod_sc" {
  name                = "vnet-sc"
  resource_group_name = "network-rg"
}
