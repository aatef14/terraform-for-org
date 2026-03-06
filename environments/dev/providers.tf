terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "core"
  subscription_id                 = var.subscription_id

  # Service Principal 
  # client_id = "value"
  # tenant_id = "value"
  # client_secret = "value"
}

provider "azapi" {
}
