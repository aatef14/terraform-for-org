# 🏗️ Terraform Infrastructure Template

This template is a production-ready framework for provisioning Azure resources with a **Security-First** mindset. It uses a modular architecture to ensure infrastructure is consistent, scalable, and fully isolated from the public internet.

---

## 📂 Project Structure

```text
terraform-for-org/
├── modules/                    # 🧩 REUSABLE BUILDING BLOCKS (shared across all environments)
│   ├── vnet/                   # 🌐 Virtual Network
│   ├── subnet/                 # 🔀 Subnet
│   ├── pdns/                   # 📛 Private DNS Zone (Shared "Phonebook")
│   ├── pep/                    # 🔒 Private Endpoint (The "Locked Gate")
│   ├── app-service/            # 🌍 Web Apps (Container-based)
│   ├── function-app-container/ # 📦 Container-based Function Apps
│   ├── storage-account/        # 💾 Azure Storage
│   ├── key-vault/              # 🔑 Azure Key Vault
│   ├── cache-for-redis/        # ⚡ Azure Cache for Redis
│   ├── apim/                   # 🔀 API Management
│   ├── service-bus/            # 📨 Service Bus
│   ├── cosmos-db/              # 🌍 Cosmos DB (NoSQL)
│   ├── postgresql/             # 🐘 PostgreSQL Flexible Server
│   ├── event-grid/             # 📡 Event Grid
│   ├── event-hub/              # 🚀 Event Hub
│   ├── logic-app/              # ⚙️ Logic App Standard
│   ├── linux-vm/               # 🐧 Linux Virtual Machines (No Public IP)
│   ├── ai-foundry-hub/         # 🧠 AI Foundry Hub
│   ├── ai-foundry-project/     # 📁 AI Foundry Project
│   ├── ai-foundry-connection/  # 🔗 AI Foundry Connections
│   ├── ai-search/              # 🔍 AI Search
│   └── open-ai-cognitive/      # 🤖 Azure OpenAI
├── environments/               # 🌍 ENVIRONMENT DEFINITIONS
│   ├── dev/                    # Development environment
│   ├── stg/                    # Staging environment
│   └── prod/                   # Production environment
├── more-info/                  # 📖 Reference Guides & Documentation
├── scripts/                    # 🛠️ Automation Scripts (env sync)
└── README.md                   # This file
```

### Environment File Breakdown

Each environment directory (`dev/`, `stg/`, `prod/`) contains:

| File | Purpose | Who Edits? |
| :--- | :--- | :--- |
| **`terraform.tfvars`** | ✏️ **THE ONLY FILE YOU NEED TO EDIT** — All values, toggles, and configurations | Everyone |
| **`main.tf`** | Heart of the environment — all compute & logic modules | Terraform devs |
| **`vnet.tf`** | 🌐 Core Networking — VNets, Subnets, and the `local.subnets` map | Terraform devs |
| **`pdns.tf`** | 📛 Private DNS Zone management — auto-provisions based on toggles | Terraform devs |
| **`pep.tf`** | 🔒 Private Endpoints — centralized registry of all PEPs | Terraform devs |
| **`foundry.tf`** | 🧠 AI Foundry Hub, Project, Search, OpenAI configurations | Terraform devs |
| **`variables.tf`** | Data contract — variable declarations and types | Terraform devs |
| **`data_source.tf`** | References to existing Azure resources (Resource Groups, DNS, VNets) | Terraform devs |
| **`providers.tf`** | Terraform provider configuration (AzureRM, AzAPI) | Terraform devs |
| **`backend.tf`** | Remote state configuration | Terraform devs |

---

## 🛡️ Networking & Architecture (The Security Triangle)

To ensure maximum security, this template follows a **Private-Link-First** strategy. Resources are hidden from the public internet using three core pillars:

### 1. 🌐 VNet Integration (Outbound)
All apps (Logic Apps, Function Apps, Web Apps) are "injected" into a Virtual Network.
*   **Purpose**: Allows the app to talk to other private resources (like a Database or Key Vault).
*   **Setting**: `vnet_route_all_enabled = true` ensures even internet traffic goes through your secure network.
*   **Multi-Region**: Two VNets — Qatar Central (`vnet_qc`) and Sweden Central (`vnet_sc`) — provide geographic distribution.

### 2. 🔒 Private Endpoints (Inbound)
Instead of a public URL, we create a Private Endpoint (**PEP**) for every service.
*   **Purpose**: This gives the service a **private IP address** within your VNet.
*   **Security**: Public network access is explicitly **disabled** at the resource level.
*   **Centralized**: All PEPs are defined in `pep.tf` using a data-driven `locals` map, filtered by feature toggles.

### 3. 📛 Private DNS Zones (Resolution)
Because resources use private IPs, we need a way to translate names (e.g., `myservice.azurewebsites.net`) to those private IPs.
*   **Purpose**: The `pdns` module creates "Zones" (the phonebook) and links them to your VNets so names resolve correctly only from inside the network.
*   **Toggle-Aware**: DNS zones are only created for enabled services (controlled by `feature_toggles`).

---

## 🚀 How to Provision Resources

*For users who just want to create resources.*

### 1. The Toggle System
In `terraform.tfvars`, turn entire categories on or off using **Feature Toggles**:
```hcl
feature_toggles = {
  storage_account = true
  app_service     = true
  function_app    = false   # Disabled — won't be created
  # ...
}

# AI services have separate toggles
enable_ai_foundry = true
enable_ai_search  = true
enable_openai     = true
```

### 2. Dynamic Placement (The Subnet Map)
When adding an app, you simply specify its `subnet_key`. The system automatically looks up the correct Resource ID from the `local.subnets` map in `vnet.tf`.

```hcl
# In vnet.tf — the subnet lookup map
locals {
  subnets = {
    fend_qc  = module.subnet_fend_qc.subnet_id
    bend_qc  = module.subnet_bend_qc.subnet_id
    func_sc  = module.subnet_func_sc.subnet_id
    # ...
  }
}
```

### 3. Adding a New Web App Instance
Just add an entry to the `app_service_config` map in `terraform.tfvars`:
```hcl
app_service_config = {
  "fend" = {
    app_service_name       = "app-frontend"
    sku_name               = "P1v3"
    subnet_key             = "fend_qc"    # ← just reference a subnet key
    zone_balancing_enabled = false
    docker_image_name      = "mcr.microsoft.com/appsvc/staticsite"
    location               = "qatarcentral"
  }
  "new-api" = {                           # ← add a new entry to scale
    app_service_name       = "app-new-api"
    sku_name               = "P1v3"
    subnet_key             = "bend_qc"
    zone_balancing_enabled = true
    docker_image_name      = "myregistry.azurecr.io/my-api:latest"
    location               = "qatarcentral"
  }
}
```

### 4. Deployment Steps
1. Navigate to the target environment directory (e.g., `environments/dev/`).
2. Run `terraform init`.
3. Run `terraform plan` to audit changes.
4. Run `terraform apply` to deploy.
5. To sync environments, use the scripts in `scripts/` folder.

---

## 🐧 Special Case: Linux VMs (No Public IP)

Our **`linux-vm`** module is configured for high security:
*   **No Public IP**: The VM has no external gateway. It is ONLY accessible from within the VNet (e.g., via a Bastion or VPN).
*   **Dynamic Subnet Placement**: Uses `local.subnets[each.value.subnet_key]` for flexible network assignment.
*   **Managed OS Disk**: Uses Standard SSDs for reliable performance.
*   **Ubuntu 22.04 LTS**: Pre-configured with the latest stable Ubuntu image.

---

## 🧠 AI Foundry Integration

The template includes full support for **Azure AI Foundry** with:
*   **AI Foundry Hub** — Central workspace for AI projects (requires Storage Account + Key Vault)
*   **AI Foundry Project** — Individual AI project linked to the Hub
*   **Azure OpenAI** — GPT-4o and text-embedding model deployments
*   **AI Search** — Cognitive Search for RAG patterns
*   **Automatic Connections** — Hub-to-OpenAI and Hub-to-Search connections are auto-created
*   **Private Endpoints** — All AI services get PEPs for secure access

Enable AI features independently:
```hcl
enable_ai_foundry = true    # Hub + Project
enable_ai_search  = true    # Cognitive Search
enable_openai     = true    # Azure OpenAI
```

---

## 🛠️ Development & Extension

*For Terraform Developers extending the template.*

### Step 1: Create the Module
1. Create a new folder in `modules/my-new-service/`.
2. Define `main.tf`, `variables.tf`, and `outputs.tf`.

### Step 2: Update Data Contract
Update `environments/dev/variables.tf` to include:
- A `map(object({...}))` variable for the new service config.
- A feature toggle key in the `feature_toggles` default map.

### Step 3: Add the Module
Add a `module` block in `main.tf` using `for_each`:
```hcl
module "my_service" {
  for_each = var.feature_toggles["my_service"] ? var.my_service_config : {}
  source   = "../../modules/my-new-service"
  name     = each.value.name
  # ... other variables
}
```

### Step 4: Add Private Endpoint (if needed)
Add an entry in `pep.tf`'s `local.private_endpoints` map:
```hcl
my_service = {
  enabled                        = var.feature_toggles["my_service"]
  name                           = "pep-${var.my_service_config["svc_1"].name}"
  subnet                         = "qc"
  private_connection_resource_id = module.my_service["svc_1"].service_id
  subresource_names              = ["mySubresource"]
  private_dns_zone_ids           = [local.dns_zone_ids["my_dns_key"]]
  # ...
}
```

### Step 5: Add DNS Zone (if needed)
Add an entry in `pdns.tf`'s `local.private_dns_zones` map:
```hcl
my_dns_key = var.feature_toggles["my_service"] ? "privatelink.myservice.azure.com" : null
```

### Step 6: Sync Environments
Run the sync script to propagate changes to `stg/` and `prod/`.

---

## 💡 Key Design Patterns

*   **Scale-via-Data**: We use `for_each` loops instead of static blocks. Scale by editing `.tfvars` without touching core logic.
*   **Toggle-Driven**: Every service category can be independently enabled/disabled via `feature_toggles`.
*   **Avoid Numeric Indices**: We use name-based keys (e.g., `["fend"]`, `["st-1"]`) instead of `[0]` to prevent accidental resource destruction during shifts.
*   **Centralized PEP Registry**: All private endpoints (except AI) are defined in a single `locals` map in `pep.tf`, filtered by the `enabled` flag.
*   **Decoupling**: We separate **Compute** (`main.tf`), **Network** (`vnet.tf`), **DNS** (`pdns.tf`), **Security** (`pep.tf`), and **AI** (`foundry.tf`) into split files for clarity.
*   **Auto-Naming**: Standardized prefixes (e.g., `pep-`, `snet-`, `vnet-`) ensure compliance.
*   **Multi-Region**: Two VNets across Qatar Central and Sweden Central provide geographic distribution.

---

## 📖 Reference Guides
*   **[How It Works — Architecture Deep Dive](more-info/how-it-works.md)**
*   **[Variable & Scaling Architecture](more-info/variables.md)**
*   **[SKU Reference Guide](more-info/sku.md)**
*   **[Private DNS & PEP Flow](more-info/pdns.md)**
*   **[AI Foundry Hub Guide](more-info/foundry.md)**

---

## 📜 License
This project is licensed under the Apache-2.0 License. See [LICENSE](LICENSE) for details.
