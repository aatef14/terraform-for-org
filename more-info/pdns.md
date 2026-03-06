# Private DNS (PDNS) & Private Endpoint (PEP) Architecture

This document explains how the Private DNS Zones are configured and how they integrate with Private Endpoints across the different environments.

## 🌐 Private DNS Zone Overview

The Private DNS configuration is managed primarily in `pdns.tf`. It uses a centralized approach to create and link DNS zones required for Azure services to resolve internally via Private Links.

### 🛠️ Key Files
- **`environments/dev/pdns.tf`**: Defines the DNS zones and their VNET links.
- **`environments/dev/pep.tf`**: Configures Private Endpoints and connects them to the DNS zones.
- **`modules/pdns/`**: The reusable module that creates the `azurerm_private_dns_zone` and `azurerm_private_dns_zone_virtual_network_link` resources.

---

## 🔗 How They Connect

The connection between Private DNS (PDNS) and Private Endpoints (PEP) follows a 3-step automated flow:

### 1. Dynamic Zone Definition (`pdns.tf`)
We define a map of all possible DNS zones. A `filtered_dns_zones` local variable ensures that only the zones for **enabled** services are actually created.
```hcl
locals {
  private_dns_zones = {
    websites   = "privatelink.azurewebsites.net"
    blob       = "privatelink.blob.core.windows.net"
    # ... other services ...
    apim       = var.feature_toggles["apim"] ? "privatelink.azure-api.net" : null
  }
}
```

### 2. DNS Zone Resource IDs (`pep.tf`)
In the `pep.tf` file, we collect the resource IDs of all created DNS zones into a local map called `dns_zone_ids`. This map allows every Private Endpoint to "find" its corresponding DNS zone.
```hcl
locals {
  dns_zone_ids = {
    for k, v in module.dns_zones : k => v.dns_zone_id
  }
}
```

### 3. Private Endpoint Registration
When a Private Endpoint is created (e.g., for a Web App), it references the specific DNS zone ID from the map. This triggers Azure to:
1. Issue a private IP to the endpoint.
2. Automatically create an **'A' record** in the DNS zone mapping the service name to that private IP.

```hcl
module "pe_app_frontend" {
  source = "../../modules/pep"
  # ...
  private_connection_resource_id = module.app_service_frontend.app_service_id
  private_dns_zone_ids           = [local.dns_zone_ids["websites"]]
}
```

---

## 🕸️ VNET Linking

For the DNS resolution to work, the Private DNS Zones must be "linked" to the Virtual Networks where the clients reside. 

In our configuration, every zone created is automatically linked to:
- **QC VNET** (`link-qc`)
- **SC VNET** (`link-sc`)

This ensures that resources in either region can resolve the private IPs of any service in the environment.

---

## 📝 Managed DNS Zones List

| Service | DNS Zone Name |
| :--- | :--- |
| **App Service / Functions** | `privatelink.azurewebsites.net` |
| **Storage (Blob)** | `privatelink.blob.core.windows.net` |
| **Storage (File)** | `privatelink.file.core.windows.net` |
| **Key Vault** | `privatelink.vaultcore.azure.net` |
| **Service Bus / Event Hub** | `privatelink.servicebus.windows.net` |
| **API Management** | `privatelink.azure-api.net` |
| **Cosmos DB** | `privatelink.documents.azure.com` |
| **AI Foundry / Services** | `privatelink.services.ai.azure.com` |
| **OpenAI** | `privatelink.openai.azure.com` |
| **AI Search** | `privatelink.search.windows.net` |
