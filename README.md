# 🏗️ Terraform Infrastructure Template

This template is designed to simplify the provisioning of Azure resources. It uses a modular architecture to ensure that infrastructure is consistent, scalable, and easy to deploy.

---

## 📂 Project Structure

```text
terraform-template/
├── modules/                # 🧩 REUSABLE BUILDING BLOCKS
│   ├── app-service/        # Logic to build Web Apps
│   ├── function-app/       # Logic to build Function Apps
│   └── ...                 # Other resource modules
└── environments/           # 🌍 ENVIRONMENT DEFINITIONS
    └── dev/                # (e.g., Development Environment)
        ├── main.tf         # Heart of the environment (links modules)
        ├── vnet.tf         # 🌐 Core Networking (VNet, Subnets)
        ├── pdns.tf         # 📛 Private DNS Zones
        ├── pep.tf          # 🔒 Private Endpoints
        ├── data_s.tf       # 💾 data sources
        ├── variables.tf    # Data structure declarations
        ├── terraform.tfvars# ✏️ THE ONLY FILE YOU NEED TO EDIT
        ├── providers.tf    # Azure authentication config
        └── backend.tf      # State file location config
```

---

## 🛡️ Networking & Architecture (PEP & PDNS)

To ensure high security, this template follows a **Private-Link-First** strategy. Resources are not exposed to the public internet; instead, they are connected to your Virtual Network via Private Endpoints.

### Why separate files (`vnet.tf`, `pdns.tf`, `pep.tf`, `data_s.tf`)?

We use a **Functional Separation** approach for environment files to maintain clarity and prevent `main.tf` from becoming unmanageable:

| File | Purpose | Why separate? |
| :--- | :--- | :--- |
| **`vnet.tf`** | Virtual Networks and Subnets | This is the **Foundation**. Networking changes are high-risk; keeping them separate prevents accidental modification while working on apps. |
| **`pdns.tf`** | Private DNS Zones | Managed as **Shared Infrastructure**. Multiple services (Logic Apps, Web Apps, SQL) often share the same DNS zone. Separation allows for cleaner VNet link management. |
| **`pep.tf`** | Private Endpoints | The **Security Map**. This file acts as a central registry of how services are linked to the network. It's easier to audit security when all PEPs are in one place. |
| **`data_s.tf`** | Stateful/Data Services | Separates **Data from Compute**. Services like Storage Accounts or Databases have different lifecycles than Apps. |
| **`main.tf`** | Compute & Logic | Focuses on **Applications** (Logic Apps, Web Apps, Functions). This is where the business logic "lives". |

### How it works:
1. **Network Foundation (`vnet.tf`)**: Creates the "pipes" and subnets.
2. **DNS Readiness (`pdns.tf`)**: Prepares the "phonebook" for private addresses (e.g., `privatelink.azurewebsites.net`).
3. **Service Logic (`main.tf`/`data_s.tf`)**: Creates the actual services (Apps/DBs) with VNet Integration for outbound traffic.
4. **Private Connection (`pep.tf`)**: Creates a Private Endpoint for inbound traffic and automatically registers the IP in the Private DNS Zone.

---

## 🚀 How to Provision Resources
*For users who just want to create resources.*

In this template, each application is managed as a **dedicated module block**. This provides granular control over individual SKUs, images, and networking settings for every frontend and backend instance.

To modify or add services, you only need to update:
`environments/dev/terraform.tfvars`

### 1. Modifying a Web App
Update the values for `app_service_name_fend`, `sku_name_fend`, etc., to change individual app settings.

### 2. Adding a New Service
1.  **Define Variables**: Ensure the new name and settings are added to `variables.tf`.
2.  **Add Module Block**: Copy a module block in `main.tf` and point it to the new variables. This approach ensures maximum flexibility for heterogeneous app landscapes.

### 3. Running the Deployment
1. Open terminal in `environments/dev/`.
2. Run `terraform init` (only the first time).
3. Run `terraform plan` to see what will be created.
4. Run `terraform apply` to provision the resources.

---

## 🕹️ Selective Provisioning (Feature Toggles)
You can control exactly which parts of the infrastructure are created without deleting any code. 

In `environments/dev/terraform.tfvars`, look for the **MODULE TOGGLES** section:

```hcl
enable_storage_account = true
enable_logic_app       = false  # This specific service will NOT be created
enable_cosmos_db       = true
```

*   **`true`**: Terraform will create/maintain the resource.
*   **`false`**: Terraform will skip creation or **destroy** the resource if it already exists.

---

## 🛠️ How to Add New Service Modules
*For Terraform Developers extending the template.*

### 🌳 Branching Strategy (MANDATORY)
Before starting any work on a new module or feature, ALWAYS create a separate feature branch:
`git checkout -b feature-<module-name-or-headline>`

**Never push directly to `main`.** Always merge via Pull Request in the GitHub Portal.

---

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

### 1. Granular Control
By using individual module blocks instead of loops, you can change the SKU or specific configuration of one app without affecting others in the same group.

### 2. Auto-Naming
Standardized prefixes (e.g., `asp-`, `pe-`, `st-`) are used within modules to ensure naming compliance across the organization.

### 3. Decoupling
*   **Modules:** Contain "How" to build.
*   **Tfvars:** Contains "What" values to use.
*   **Split Files:** Separate Network, DNS, and Compute logic for clarity.
