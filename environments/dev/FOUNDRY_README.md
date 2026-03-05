# Azure AI Foundry Module Guide

This document explains the structure of the AI Foundry modules and how to configure them for your environment.

## Architecture Overview

The AI infrastructure is built on a "Hub and Project" model:
1. **AI Foundry Hub**: The central management resource that provides security, identity, and shared infrastructure (Storage Account, Key Vault).
2. **AI Foundry Project**: A collaborative workspace within the Hub where you build and deploy AI models.
3. **AI Services**: External resources (OpenAI, AI Search) that are "connected" to the Hub.

## Module Structure

The modules are located in `/modules/`:
- `ai-foundry-hub`: Creates the central hub.
- `ai-foundry-project`: Creates projects nested under the hub.
- `ai-foundry-connection`: Connects external services to the hub using `azapi`.
- `ai-search`: Standard search service module.
- `open-ai-cognitive`: OpenAI service with support for multiple model deployments.

## Environment Configuration (`environments/dev/foundry.tf`)

All AI logic is separated into `foundry.tf` to keep the main configuration clean.

### 1. Enable Modules
In your `terraform.tfvars`, set the following toggles to `true`:
```hcl
enable_ai_foundry = true
enable_ai_search  = true
enable_openai     = true
```

### 2. Configure Service Details
You can change the names and SKUs in `terraform.tfvars`:
```hcl
ai_foundry_hub_name     = "qe-ai-hub"
ai_foundry_project_name = "qe-ai-project"
ai_search_name          = "qe-ai-search"
openai_name             = "qe-openai"
```

### 3. Adding AI Models
To deploy new models (like GPT-4o or Embeddings), update the `openai_deployments` map in `terraform.tfvars`:
```hcl
openai_deployments = {
  "gpt-4o-v1" = {
    model_name    = "gpt-4o"
    model_version = "2024-05-13"
  },
  "embeddings-v1" = {
    model_name    = "text-embedding-3-small"
    model_version = "1"
  }
}
```

## Private Networking & DNS

The modules automatically create **Private Endpoints** for the Hub, Search, and OpenAI services. 
- They are connected to the `subnet_pep_qc` subnet.
- They are integrated with Private DNS Zones managed in `pdns.tf` (linked to both QC and SC VNets):
    - `privatelink.services.ai.azure.com` (AIServices)
    - `privatelink.search.windows.net` (Search)
    - `privatelink.openai.azure.com` (OpenAI)

## Future Configuration Tips
1. **Adding a new Project**: Simply duplicate the `module "ai_foundry_project"` block in `foundry.tf` with a new name.
2. **Connecting another service**: Use the `module "ai_foundry_connection"` pattern to link new Search or AI services to the existing Hub.
3. **Region Changes**: Most AI services require specific regions. Always verify model availability in your target region before changing the `location`.
