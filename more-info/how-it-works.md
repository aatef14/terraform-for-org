# 🔬 How It Works — Architecture Deep Dive

This document explains how all the pieces of the Terraform template connect together, how data flows between files, and how the system scales.

---

## 🏗️ The Big Picture

The infrastructure is built in **layers**, and each layer depends on the one below it. Think of it like building a house:

```
┌─────────────────────────────────────────────────────────┐
│  Layer 5: AI SERVICES (foundry.tf)                      │
│  AI Hub, Projects, OpenAI, Search, AI Connections       │
├─────────────────────────────────────────────────────────┤
│  Layer 4: PRIVATE ENDPOINTS (pep.tf)                    │
│  Secure inbound access — one module, data-driven map    │
├─────────────────────────────────────────────────────────┤
│  Layer 3: PRIVATE DNS ZONES (pdns.tf)                   │
│  Name resolution for privatelink domains                │
├─────────────────────────────────────────────────────────┤
│  Layer 2: COMPUTE & SERVICES (main.tf)                  │
│  App Services, Functions, Redis, CosmosDB, etc.         │
├─────────────────────────────────────────────────────────┤
│  Layer 1: NETWORKING (vnet.tf)                          │
│  VNets, Subnets, and the subnet lookup map              │
├─────────────────────────────────────────────────────────┤
│  Layer 0: FOUNDATION (providers.tf, data_source.tf)     │
│  Provider config, existing resource group references    │
└─────────────────────────────────────────────────────────┘
```

Each layer is a separate `.tf` file, and Terraform resolves the dependencies automatically.

---

## 📁 File-by-File Breakdown

### 1. `providers.tf` — The Entry Point

This is where Terraform is told **which cloud** to talk to and **how** to authenticate.

```
providers.tf
    ↓ sets up
AzureRM Provider (v4.x) + AzAPI Provider
    ↓ uses
var.subscription_id (from terraform.tfvars)
```

### 2. `data_source.tf` — References to What Already Exists

Instead of creating a resource group from scratch, we reference **existing** Azure resources:

```
data_source.tf
    ↓ reads
Existing Resource Group  →  data.azurerm_resource_group.rg_dev
Existing DNS Zones       →  data.azurerm_private_dns_zone.*
Existing VNets           →  data.azurerm_virtual_network.*
Current Azure Session    →  data.azurerm_client_config.current
```

These are used throughout all other files as the foundation.

### 3. `variables.tf` — The Data Contract

This file **declares** what data the environment expects. It defines:

- The **shape** of each service configuration (using `map(object({...}))`)
- The **feature toggles** with sensible defaults
- The **networking variables** (VNet names, subnet prefixes)

```
variables.tf declares:
    var.feature_toggles          → map(bool): toggle services on/off
    var.app_service_config       → map(object): web app definitions
    var.function_app_config      → map(object): function app definitions
    var.storage_account_config   → map(object): storage definitions
    var.redis_config             → map(object): redis cache definitions
    ... and all other services
```

### 4. `terraform.tfvars` — THE ONLY FILE YOU EDIT

This provides the **actual values** that fill in the contract:

```
terraform.tfvars provides:
    feature_toggles = { app_service = true, redis = false, ... }
    app_service_config = { "fend" = { name = "...", subnet_key = "fend_qc" }, ... }
    vnet_name_qc = "vnet-qe-qisp-stg-qc-01"
    ... etc
```

---

## 🔄 How Data Flows Between Files

Here is the complete data flow from a user editing `terraform.tfvars` to a resource being deployed:

```
terraform.tfvars                    variables.tf
┌──────────────────┐           ┌──────────────────┐
│ feature_toggles  │──values──→│ var.feature_toggles│
│ app_service_config│──values──→│ var.app_service_  │
│ vnet_name_qc     │──values──→│ var.vnet_name_qc  │
└──────────────────┘           └──────────────────┘
                                        │
                    ┌───────────────────┤
                    ↓                   ↓
              vnet.tf              main.tf
         ┌──────────────┐    ┌──────────────────┐
         │ module.vnet_qc│    │ module.app_service│
         │ module.subnet*│    │ module.redis_cache│
         │ local.subnets │    │ module.key_vault  │
         └──────┬───────┘    └────────┬─────────┘
                │                     │
                │ subnet IDs          │ resource IDs
                ↓                     ↓
              pdns.tf              pep.tf
         ┌──────────────┐    ┌──────────────────────┐
         │ module.dns_   │    │ local.private_        │
         │   zones       │    │   endpoints (map)     │
         └──────┬───────┘    │ local.enabled          │
                │             │   (filtered map)       │
                │ zone IDs    │ module.private_         │
                └────────────→│   endpoints            │
                              └──────────────────────┘
```

---

## ⚙️ Detailed: How Each Subsystem Works

### The Toggle System

Every service is controlled by a boolean flag in `var.feature_toggles`. The pattern used everywhere is:

```hcl
for_each = var.feature_toggles["service_name"] ? var.service_config : {}
```

**How it works:**
- If `feature_toggles["service_name"]` is `true` → iterate over the config map → create resources
- If `feature_toggles["service_name"]` is `false` → use an empty map `{}` → create nothing

This pattern is used in:
- `main.tf` — for all compute modules
- `pdns.tf` — for conditional DNS zone creation
- `pep.tf` — for the `enabled` flag on each private endpoint entry

### The Subnet Map (`vnet.tf`)

Instead of hardcoding subnet IDs, we use a **lookup map**:

```hcl
# In vnet.tf
locals {
  subnets = {
    fend_qc  = module.subnet_fend_qc.subnet_id
    bend_qc  = module.subnet_bend_qc.subnet_id
    pep_qc   = module.subnet_pep_qc.subnet_id
    pep_sc   = module.subnet_pep_sc.subnet_id
    func_sc  = module.subnet_func_sc.subnet_id
    logic_sc = module.subnet_logic_sc.subnet_id
  }
}
```

Then in `main.tf`, a service just references its key:
```hcl
vnet_subnet_id = local.subnets[each.value.subnet_key]
# e.g. each.value.subnet_key = "fend_qc" → resolves to the actual subnet resource ID
```

**Benefits:**
- Adding a new subnet only requires editing `vnet.tf` + `terraform.tfvars`
- Services are decoupled from specific subnet resources
- Moving a service to a different subnet = changing one string in `.tfvars`

### Private DNS Zones (`pdns.tf`)

DNS zones are **conditionally created** based on feature toggles:

```hcl
# In pdns.tf
locals {
  private_dns_zones = {
    websites   = var.feature_toggles["app_service"] ? "privatelink.azurewebsites.net" : null
    blob       = var.feature_toggles["storage_account"] ? "privatelink.blob.core.windows.net" : null
    keyvault   = var.feature_toggles["key_vault"] ? "privatelink.vaultcore.azure.net" : null
    # ... etc
  }

  # Remove nulls → only enabled zones remain
  filtered_dns_zones = {
    for k, v in local.private_dns_zones : k => v if v != null
  }
}

module "dns_zones" {
  for_each = local.filtered_dns_zones
  source   = "../../modules/pdns"
  # ...
}
```

**How it works:**
1. Each DNS zone is mapped to a feature toggle
2. If the feature is disabled, the zone value is `null`
3. The `filtered_dns_zones` local removes all `null` values
4. Only enabled DNS zones are created

### Private Endpoints (`pep.tf`) — The Data-Driven Approach

This is the most sophisticated pattern in the template. Instead of having 15+ separate `module` blocks, we use a **single locals map** + **one module block**:

```hcl
# Step 1: Build DNS zone ID lookup
locals {
  dns_zone_ids = {
    for k, v in module.dns_zones : k => v.dns_zone_id
  }
}

# Step 2: Define all PEPs in a single map
locals {
  pep_subnets = {
    qc = module.subnet_pep_qc.subnet_id
    sc = module.subnet_pep_sc.subnet_id
  }

  private_endpoints = {
    front_end = {
      enabled                        = var.feature_toggles["app_service"]
      name                           = "pep-${var.app_service_config["fend"].app_service_name}"
      subnet                         = "qc"
      private_connection_resource_id = module.app_service["fend"].app_service_id
      subresource_names              = ["sites"]
      private_dns_zone_ids           = [local.dns_zone_ids["websites"]]
      # ...
    }
    storage_blob = {
      enabled                        = var.feature_toggles["storage_account"]
      # ...
    }
    # ... all other services
  }

  # Step 3: Filter to only enabled PEPs
  enabled = {
    for k, v in local.private_endpoints : k => v if v.enabled
  }
}

# Step 4: One module creates them all
module "private_endpoints" {
  source   = "../../modules/pep"
  for_each = local.enabled     # ← only enabled entries

  name                           = each.value.name
  subnet_id                      = local.pep_subnets[each.value.subnet]
  private_connection_resource_id = each.value.private_connection_resource_id
  subresource_names              = each.value.subresource_names
  private_dns_zone_ids           = each.value.private_dns_zone_ids
  # ...
}
```

**How it works step by step:**
1. `dns_zone_ids` builds a lookup map from the DNS zones module (e.g., `"websites" → "/subscriptions/.../zones/..."`)
2. `pep_subnets` maps region codes (`"qc"`, `"sc"`) to actual subnet IDs
3. `private_endpoints` defines **every** PEP as a map entry with an `enabled` flag
4. `enabled` filters out any PEP whose service is toggled off
5. A single `module "private_endpoints"` creates all enabled PEPs in one loop

**Why this is better than individual module blocks:**
- **Single place to manage**: All PEPs are visible in one map
- **Easy to add**: Copy-paste an entry, change the values
- **Toggle-aware**: Disabled services automatically skip their PEPs
- **Consistent**: Every PEP follows the exact same structure

---

## 🔗 How the Three Pillars Connect

Here's how VNet Integration, Private Endpoints, and Private DNS Zones work together:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        VIRTUAL NETWORK (vnet.tf)                    │
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │ snet-frontend│  │ snet-backend │  │ snet-pep     │             │
│  │              │  │              │  │  (Private    │             │
│  │  Web App     │  │  Web App     │  │  Endpoints   │             │
│  │  (VNet       │  │  (VNet       │  │  land here)  │             │
│  │  Integrated) │  │  Integrated) │  │              │             │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘             │
│         │                 │                 │                       │
│         │    Outbound     │    Outbound     │  Private IPs          │
│         │    traffic      │    traffic      │  10.0.0.x             │
│         ↓                 ↓                 ↓                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              Private DNS Zone (pdns.tf)                      │   │
│  │  "privatelink.azurewebsites.net" → 10.0.0.5                │   │
│  │  "privatelink.blob.core.windows.net" → 10.0.0.6            │   │
│  │  "privatelink.vaultcore.azure.net" → 10.0.0.7              │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                               │
                               │ resolves to private IP
                               ↓
┌─────────────────────────────────────────────────────────────────────┐
│                    AZURE SERVICES (main.tf)                         │
│                                                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐             │
│  │ Storage  │ │ Key Vault│ │  Redis   │ │ CosmosDB │             │
│  │ Account  │ │          │ │  Cache   │ │          │             │
│  │          │ │          │ │          │ │          │             │
│  │ Public   │ │ Public   │ │ Public   │ │ Public   │             │
│  │ Access:  │ │ Access:  │ │ Access:  │ │ Access:  │             │
│  │ DISABLED │ │ DISABLED │ │ DISABLED │ │ DISABLED │             │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘             │
│         ↑           ↑           ↑           ↑                      │
│         └───────────┴───────────┴───────────┘                      │
│                    Connected via PEPs (pep.tf)                      │
└─────────────────────────────────────────────────────────────────────┘
```

**The flow when Web App calls Storage Account:**
1. Web App in `snet-frontend` needs to access `mystorageaccount.blob.core.windows.net`
2. DNS resolution hits the Private DNS Zone → resolves to `10.0.0.6` (private IP)
3. Traffic stays entirely within the VNet → hits the Private Endpoint in `snet-pep`
4. Private Endpoint connects to the Storage Account's internal interface
5. Storage Account's public endpoint is **disabled** — no internet exposure

---

## 📈 Scalability Patterns

### Adding a New Service Instance

**Effort: Edit 1 file (`terraform.tfvars`)**

To add a second Storage Account, just add another entry:
```hcl
storage_account_config = {
  "st-1" = { storage_account_name = "storage1", ... }
  "st-2" = { storage_account_name = "storage2", ... }   # ← just add this
}
```
The `for_each` in `main.tf` automatically creates both.

### Adding a New Service Type

**Effort: Edit 4-5 files**

1. **Create module** → `modules/my-service/`
2. **Declare variable** → `variables.tf` (add `var.my_service_config`)
3. **Add values** → `terraform.tfvars`
4. **Add module block** → `main.tf` (with `for_each`)
5. **Add PEP entry** → `pep.tf` (in `local.private_endpoints`)
6. **Add DNS zone** → `pdns.tf` (if service needs its own `privatelink.*` zone)

### Adding a New Environment

**Effort: Copy + edit `terraform.tfvars`**

1. Copy the `dev/` directory to a new folder (e.g., `dr/`)
2. Edit `terraform.tfvars` with environment-specific values
3. Update `backend.tf` to point to a different state file
4. Run `terraform init` + `terraform apply`

Or use the sync scripts in `scripts/` to auto-copy from `dev/`.

### Adding a New Region

**Effort: Add to `vnet.tf` + `terraform.tfvars`**

1. Add a new VNet module in `vnet.tf` (e.g., `module "vnet_nc"`)
2. Add new subnet modules for the region
3. Add subnet entries to `local.subnets`
4. Add a VNet link in `pdns.tf`'s module block
5. Set values in `terraform.tfvars`

---

## 🔄 Environment Synchronization

The `scripts/` directory contains sync scripts that copy `.tf` and `.tfvars` files from `dev/` to `stg/` and `prod/`:

```
scripts/
├── sync_environments.ps1    # Windows (PowerShell)
└── sync_environments.sh     # Linux/macOS (Bash)
```

**Workflow:**
1. Make all structural changes in `dev/`
2. Test with `terraform plan` in `dev/`
3. Run the sync script to copy to `stg/` and `prod/`
4. Edit `terraform.tfvars` in each environment for environment-specific values

---

## 🧩 Module Interface Pattern

Every module follows the same interface pattern:

```
modules/my-service/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables
└── outputs.tf       # Output values (IDs, names, endpoints)
```

**Key outputs used by other files:**
| Module | Output | Used By |
| :--- | :--- | :--- |
| `app-service` | `.app_service_id` | `pep.tf` (for PEP connection) |
| `storage-account` | `.storage_account_id` | `pep.tf`, `foundry.tf` |
| `key-vault` | `.key_vault_id` | `pep.tf`, `foundry.tf` |
| `pdns` | `.dns_zone_id` | `pep.tf` (via `local.dns_zone_ids`) |
| `vnet` | `.vnet_id` | `pdns.tf` (for VNet linking) |
| `subnet` | `.subnet_id` | `vnet.tf` (via `local.subnets`), `pep.tf` (via `local.pep_subnets`) |

---

## 🗺️ Complete Dependency Graph

```
terraform.tfvars
       │
       ↓
variables.tf (declares types)
       │
       ├──→ providers.tf (subscription_id)
       │
       ├──→ data_source.tf (resource_group_name)
       │          │
       │          ↓
       ├──→ vnet.tf (VNet/Subnet config)
       │       │
       │       ├── local.subnets map
       │       │        │
       │       ↓        ↓
       ├──→ main.tf (compute modules)
       │       │        uses local.subnets for VNet integration
       │       │
       │       ↓ outputs resource IDs
       │       │
       ├──→ pdns.tf (DNS zones)
       │       │
       │       ↓ outputs dns_zone_ids
       │       │
       ├──→ pep.tf (private endpoints)
       │       │    uses: resource IDs from main.tf
       │       │    uses: dns_zone_ids from pdns.tf
       │       │    uses: subnet IDs from vnet.tf
       │       │
       └──→ foundry.tf (AI services)
                uses: storage + keyvault from main.tf
                uses: dns_zone_ids from pdns.tf (via pep.tf locals)
```

---

## ✅ Summary

| Concept | How It's Implemented |
| :--- | :--- |
| **One file to edit** | `terraform.tfvars` — all values, toggles, configs |
| **Feature toggles** | `var.feature_toggles` map — booleans per service |
| **Dynamic subnets** | `local.subnets` map in `vnet.tf` — key-based lookup |
| **Conditional DNS** | `local.filtered_dns_zones` — removes nulls from toggled map |
| **Centralized PEPs** | `local.private_endpoints` + `local.enabled` in `pep.tf` |
| **One module call** | `module "private_endpoints"` iterates over `local.enabled` |
| **Multi-region** | Two VNets (Qatar Central + Sweden Central), both linked to DNS |
| **AI integration** | Separate `foundry.tf` with independent toggles |
| **Env consistency** | Sync scripts copy `dev/` → `stg/` + `prod/` |
| **Scale up** | Add entries to `terraform.tfvars` maps |
| **Scale out** | Copy environment directory, change values |
