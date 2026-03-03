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

### 📂 Why separate files (`vnet.tf`, `pdns.tf`, `pep.tf`, `data_s.tf`)?

We use a **Functional Separation** approach for environment files to maintain clarity and prevent `main.tf` from becoming unmanageable:

| File | Purpose | Why separate? |
| :--- | :--- | :--- |
| **`vnet.tf`** | Virtual Networks and Subnets | This is the **Foundation**. Networking changes are high-risk; keeping them separate prevents accidental modification while working on apps. |
| **`pdns.tf`** | Private DNS Zones | Managed as **Shared Infrastructure**. Multiple services (Logic Apps, Web Apps, SQL) often share the same DNS zone. Separation allows for cleaner VNet link management. |
| **`pep.tf`** | Private Endpoints | The **Security Map**. This file acts as a central registry of how services are linked to the network. It's easier to audit security when all PEPs are in one place. |
| **`data_s.tf`** | Data/Storage Services | Separates **Data from Compute**. Services like Storage Accounts or Databases have different lifecycles than Apps. |
| **`main.tf`** | Compute & Logic | Focuses on **Applications** (Logic Apps, Web Apps, Functions). This is where the business logic "lives". |

---

## 🐧 Special Case: Linux VMs (No Public IP)
Our **`linux-vm`** module is configured for high security:
*   **No Public IP**: The VM has no external gateway. It is ONLY accessible from within the VNet (e.g., via a Bastion or VPN).
*   **Managed OS Disk**: Uses Standard SSDs for reliable performance.
*   **Ubuntu 22.04 LTS**: Pre-configured with the latest stable Ubuntu image.

---

## 🚀 How to Provision Resources
*For users who just want to create resources.*

In this template, each application is managed as a **dedicated module block**. This provides granular control over individual SKUs and networking settings for every instance.

### 1. The Toggle System
In `environments/dev/terraform.tfvars`, you can turn entire services on or off using **Feature Toggles**:
```hcl
enable_logic_app    = true   # Created
enable_vm_linux     = false  # Skipped
enable_event_hub    = true   # Created
```

### 2. Variable Overrides
Update the values in `terraform.tfvars` to change settings. For example:
```hcl
event_hub_sku      = "Standard"
event_hub_capacity = 3  # Set Throughput Units
```

### 3. Deployment Steps
1. Navigate to `environments/dev/`.
2. Run `terraform init`.
3. Run `terraform plan` to audit changes.
4. Run `terraform apply` to deploy.

---

## 🛠️ How to Add New Service Modules
*For Terraform Developers extending the template.*

### 🌳 Branching Strategy (MANDATORY)
Before starting any work on a new module or feature, ALWAYS create a separate feature branch:
`git checkout -b feature-<module-name-or-headline>`

**Never push directly to `main`.** Always merge via Pull Request in the GitHub Portal.

### Step 1: Create the Module
1. Create a new folder in `modules/my-new-service/`.
2. Add `main.tf` (resource logic), `variables.tf` (inputs), and `outputs.tf`.

### Step 2: Declare the Variable
1. Go to `environments/dev/variables.tf`.
2. Define the configuration variables needed for your service.

### Step 3: Link in Main
1. Go to `environments/dev/main.tf` (or `data_s.tf` for data/storage).
2. Add the unique module block:
   ```hcl
   module "my_new_service" {
     source = "../../modules/my-new-service"
     name   = var.my_new_service_name
     # ... Pass other variables
   }
   ```

---

## 💡 Key Design Patterns

*   **Granular Control**: We use individual module blocks instead of loops. This allows you to set a unique SKU for "App A" without affecting "App B".
*   **Decoupling**: We separate **Compute**, **Network**, and **Security** logic into split files for clarity and lower risk.
*   **Shorthand Modules**: Use `pdns` and `pep` modules for clean, readable code in your environment files.
*   **Auto-Naming**: Standardized prefixes (e.g., `pe-`, `st-`) are used within modules to ensure compliance.

---

## 📖 Reference Guides
*   **[SKU_GUIDE.md](file:///c:/Users/MohammedAatef/Desktop/Project/terraform-template%20-%20Copy/SKU_GUIDE.md)**: Look here for a full list of valid SKUs and Tiers.
