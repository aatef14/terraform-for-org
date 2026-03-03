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
        ├── data_s.tf       # 💾 Data Source 
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

## 🐧 Special Case: Linux VMs (No Public IP)
Our **`linux-vm`** module is configured for high security:
*   **No Public IP**: The VM has no external gateway. It is ONLY accessible from within the VNet (e.g., via a Bastion or VPN).
*   **Managed OS Disk**: Uses Standard SSDs for reliable performance.
*   **Ubuntu 22.04 LTS**: Pre-configured with the latest stable Ubuntu image.

---

## 🚀 How to Provision Resources

### 1. The Toggle System
In `environments/dev/terraform.tfvars`, you can turn entire services on or off using **Feature Toggles**:
```hcl
enable_logic_app    = true   # Created
enable_vm_linux     = false  # Skipped
enable_event_hub    = true   # Created
```

### 2. Variable Overrides
Change names, SKUs, and capacities in one place. For example, to change an Event Hub's performance:
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

## 💡 Key Design Patterns

*   **Granular Control**: We use individual module blocks instead of loops. This allows you to set a unique SKU for "App A" without affecting "App B".
*   **Decoupling**: We separate **Compute** (`main.tf`), **Network** (`vnet.tf`), and **Security** (`pep.tf`) so you can modify one without risking the others.
*   **Shorthand Modules**: Use `pdns` and `pep` modules for clean, readable code in your environment files.

---

## 📖 Reference Guides
*   **[SKU_GUIDE.md](file:///c:/Users/MohammedAatef/Desktop/Project/terraform-template%20-%20Copy/SKU_GUIDE.md)**: Look here for a full list of valid SKUs and Tiers.
