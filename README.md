# 🏗️ Terraform Infrastructure Template

This template is a production-ready framework for provisioning Azure resources with a **Security-First** mindset. It uses a modular architecture to ensure infrastructure is consistent, scalable, and fully isolated from the public internet.

---

## 📂 Project Structure

```text
terraform-template/
├── modules/                # 🧩 REUSABLE BUILDING BLOCKS
│   ├── pdns/               # 📛 Private DNS Zone (Shared "Phonebook")
│   ├── pep/                # 🔒 Private Endpoint (The "Locked Gate")
│   ├── event-hub/          # 🚀 Event Hubs Messaging
│   ├── linux-vm/           # 🐧 Private Linux Servers (No Public IP)
│   ├── function-app-container/# 📦 Container-based Function Apps
│   └── ...                 # Other resource modules
└── environments/           # 🌍 ENVIRONMENT DEFINITIONS
    └── dev/                # (Example: Development Environment)
        ├── main.tf         # Heart of the environment (Apps/Logic)
        ├── vnet.tf         # 🌐 Core Networking (VNet/Subnets)
        ├── pdns.tf         # 📛 Private DNS Zone Management
        ├── pep.tf          # 🔒 All Private Endpoints in one place
        ├── data_s.tf       # 💾 Data & Storage Services
        ├── variables.tf    # Data structure declarations
        ├── terraform.tfvars# ✏️ THE ONLY FILE YOU NEED TO EDIT
```

---

## 🛡️ Networking & Architecture (The Security Triangle)

To ensure maximum security, this template follows a **Private-Link-First** strategy. Resources are hidden from the public internet using three core pillars:

### 1. 🌐 VNet Integration (Outbound)
All apps (Logic Apps, Function Apps, Web Apps) are "injected" into a Virtual Network.
*   **Purpose**: Allows the app to talk to other private resources (like a Database or Key Vault).
*   **Setting**: `vnet_route_all_enabled = true` ensures even internet traffic goes through your secure network.

### 2. 🔒 Private Endpoints (Inbound)
Instead of a public URL, we create a Private Endpoint (**PEP**) for every service.
*   **Purpose**: This gives the service a **private IP address** within your VNet.
*   **Security**: Public network access is explicitly **disabled** at the resource level.

### 3. 📛 Private DNS Zones (Resolution)
Because resources use private IPs, we need a way to translate names (e.g., `myservice.azurewebsites.net`) to those private IPs.
*   **Purpose**: The `pdns` module creates "Zones" (the phonebook) and links them to your VNets so names resolve correctly only from inside the network.

---

### 📂 Why separate files (`vnet.tf`, `pdns.tf`, `pep.tf`, `data_source.tf`)?

We use a **Functional Separation** approach to maintain clarity and prevent `main.tf` from becoming unmanageable:

| File | Purpose | Why separate? |
| :--- | :--- | :--- |
| **`vnet.tf`** | VNets, Subnets, and Subnet Map | This is the **Foundation**. Networking changes are high-risk. This file also contains the `local.subnets` map used for dynamic placement. |
| **`pdns.tf`** | Private DNS Zones | Managed as **Shared Infrastructure**. Links to both regional VNets to ensure services resolve across the entire organization. |
| **`pep.tf`** | Private Endpoints | The **Security Map**. Central registry of how services (Web Apps, SQL, AI) are linked to the network. |
| **`data_source.tf`** | Existing Resource Groups/PNZs | Separation of concerns for resources managed outside of this specific Terraform workspace. |
| **`main.tf`** | Compute & Logic | Focuses on **Applications** (Web Apps, Functions, KeyVault). This is where the business logic "lives". |

---

## 🐧 Special Case: Linux VMs (No Public IP)
Our **`linux-vm`** module is configured for high security:
*   **No Public IP**: The VM has no external gateway. It is ONLY accessible from within the VNet (e.g., via a Bastion or VPN).
*   **Managed OS Disk**: Uses Standard SSDs for reliable performance.
*   **Ubuntu 22.04 LTS**: Pre-configured with the latest stable Ubuntu image.

---

## 🚀 How to Provision Resources
*For users who just want to create resources.*

In this template, most applications are managed using **`for_each` maps**. This provides extreme scalability while maintaining granular control over individual settings.

### 1. The Toggle System
In `terraform.tfvars`, turn entire categories on or off using **Feature Toggles**:
```hcl
feature_toggles = {
  storage_account = true
  function_app     = true
  # ...
}
```

### 2. Dynamic Placement (The Subnet Map)
When adding an app, you simply specify its `subnet_key`. The system automatically looks up the correct Resource ID from the map in `vnet.tf`.

### 3. Adding an Instance
To add a new Web App, just add an entry to the `app_service_config` map in `terraform.tfvars`:
```hcl
app_service_config = {
  "new-app" = {
    app_service_name       = "qe-new-api"
    sku_name               = "P1v3"
    subnet_key             = "bend_qc"
    # ...
  }
}
```

### 4. Deployment Steps
1. Navigate to `environments/dev/`.
2. Run `terraform init`.
3. Run `terraform plan` to audit changes.
4. Run `terraform apply` to deploy.

---

## 🛠️ Development & Extension
*For Terraform Developers extending the template.*

### Step 1: Create the Module
1. Create a new folder in `modules/my-new-service/`.
2. Define `main.tf`, `variables.tf`, and `outputs.tf`.

### Step 2: Update Data Contract
Update `environments/dev/variables.tf` to include a map variable for your new service type.

### Step 3: Integrated Loop
Add a `module` block in `main.tf` using `for_each` that iterates over your new map. Always use the `local.subnets` map for network integration to keep the code clean.

---

## 💡 Key Design Patterns

*   **Scale-via-Data**: We use `for_each` loops instead of static blocks. This allows you to scale by editing `.tfvars` without modifying core logic.
*   **Avoid Numeric Indices**: We use name-based keys (e.g., `["fend"]`) instead of `[0]` to prevent accidental resource destruction during shifts.
*   **Decoupling**: We separate **Compute**, **Network**, and **Security** logic into split files for clarity and lower risk.
*   **Auto-Naming**: Standardized prefixes (e.g., `pe-`, `st-`) are used within modules to ensure compliance.

---

## 📖 Reference Guides
*   **[Variable & Scaling Architecture](more-info/variables.md)**
*   **[SKU Reference Guide](more-info/sku.md)**
*   **[Private DNS & PEP Flow](more-info/pdns.md)**
*   **[AI Foundry Hub Guide](more-info/foundry.md)**
