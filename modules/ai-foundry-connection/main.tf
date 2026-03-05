terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

# This resource facilitates connecting AI services (like OpenAI or Search) to the Hub.
# In many cases, these connections are better managed via the hub itself or azapi if specific features are needed.

resource "azapi_resource" "connection" {
  type      = "Microsoft.MachineLearningServices/workspaces/connections@2024-04-01-preview"
  name      = var.name
  parent_id = var.hub_id

  body = jsonencode({
    properties = {
      category      = var.category
      target        = var.target
      authType      = var.auth_type
      credentials   = var.credentials
      isSharedToAll = var.is_shared
      metadata      = var.metadata
    }
  })
}
