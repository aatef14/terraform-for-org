resource "azurerm_cognitive_account" "openai" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "OpenAI"
  sku_name = var.sku_name

  custom_subdomain_name = var.name

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

resource "azurerm_cognitive_deployment" "model" {
  for_each = var.deployments

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = "Standard"
    capacity = 1
  }
}
