# Azure AI Foundry & AI Services Guide

This document explains the AI infrastructure setup, including the AI Foundry Hub, Projects, and associated Azure AI services.

## 🏗️ Architecture: The Hub & Project Model

Our AI infrastructure is organized using the modern Azure AI Foundry architecture:

1.  **AI Foundry Hub**: The management "parent" resource. It handles security, identity, and shared infrastructure connections.
2.  **AI Foundry Project**: A workspace nested under the Hub. This is where users collaborate, build prompts, and manage deployments.
3.  **Connected Services**: External services like Azure OpenAI and AI Search are "linked" to the Hub so they can be shared across multiple projects.

---

## 🛠️ Components & Modules

### 1. The Hub (`modules/ai-foundry-hub`)
The Hub requires two dependencies for its internal operations:
- **Storage Account**: Stores metadata, experiments, and assets.
- **Key Vault**: Securely manages secrets and connection strings for linked services.

### 2. The Project (`modules/ai-foundry-project`)
Created within the Hub. You can create multiple projects by adding more module blocks in `foundry.tf`.

### 3. Connections (`modules/ai-foundry-connection`)
We use `azapi` to create connections between the Hub and AI services. This allows the AI Foundry portal to use the keys/endpoints of OpenAI and Search automatically.

---

## 🔒 Private Networking

All AI components are secured via **Private Endpoints**:

- **Hub Private Endpoint**: Uses the `amlworkspace` subresource and integrates with the `privatelink.services.ai.azure.com` DNS zone.
- **AI Search Private Endpoint**: Uses the `searchService` subresource and integrates with `privatelink.search.windows.net`.
- **OpenAI Private Endpoint**: Uses the `account` subresource and integrates with `privatelink.openai.azure.com`.

All endpoints are placed in the `subnet_pep_qc` subnet for consistent network architecture.

---

## ⚙️ Configuration (Toggles)

To enable the AI suite, ensure these variables are set in `terraform.tfvars`:

```hcl
enable_ai_foundry = true
enable_ai_search  = true
enable_openai     = true

# Required dependencies
feature_toggles = {
  storage_account = true
  key_vault       = true
}
```

## 🚀 Adding AI Models

To deploy new models (e.g., GPT-4), update the `openai_deployments` map. Our module will automatically provision the deployments within the OpenAI service:

```hcl
openai_deployments = {
  "gpt-4o" = {
    model_name    = "gpt-4o"
    model_version = "2024-05-13"
  }
}
```
