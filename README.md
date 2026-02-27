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
        ├── main.tf         # Logic loop linking modules to data
        ├── variables.tf    # Declaration of data structures
        ├── terraform.tfvars# ✏️ THE ONLY FILE YOU NEED TO EDIT
        ├── providers.tf    # Azure authentication config
        └── backend.tf      # State file location config
```

---

## 🚀 How to Provision Resources
*For users who just want to create resources.*

If you need to add more App Services or Functions, you only need to modify **one file**:
`environments/dev/terraform.tfvars`

### 1. Adding a Web App
Find the `app_services_web_app` block and copy-paste an existing entry:
```hcl
app_services_web_app = {
  new_app = {              # Unique ID for Terraform
    name           = "app-my-new-service-01"
    sku            = "B1"
    zone_balancing = false
    docker_image   = "mcr.microsoft.com/..."
  }
}
```
*Note: The App Service Plan is automatically created as `asp-app-my-new-service-01`.*

### 2. Adding a Function App
Find the `function_container_premium` block and add a new entry similar to the one above.

### 3. Running the Deployment
1. Open terminal in `environments/dev/`.
2. Run `terraform init` (only the first time).
3. Run `terraform plan` to see what will be created.
4. Run `terraform apply` to provision the resources.

---

## 🛠️ How to Add New Service Modules
*For Terraform Developers extending the template.*

If you want to add a brand new Azure service (e.g., Azure SQL, CosmosDB) to this template, follow these 3 steps:

### Step 1: Create the Module
1. Create a new folder in `modules/my-new-service/`.
2. Add `main.tf` (resource logic), `variables.tf` (inputs), and `outputs.tf`.

### Step 2: Declare the Variable
1. Go to `environments/dev/variables.tf`.
2. Define how the data should look (e.g., `variable "my_new_service_config" { type = map(object({...})) }`).

### Step 3: Link in Main
1. Go to `environments/dev/main.tf`.
2. Add the module block using `for_each`:
   ```hcl
   module "my_service" {
     for_each = var.my_new_service_config
     source   = "../../modules/my-new-service"
     # Pass variables using each.value
   }
   ```

---

## 💡 Key Design Patterns

### 1. DRY (Don't Repeat Yourself)
By using `for_each`, we avoid copy-pasting code in `main.tf`. One module block can create 1 or 100 resources based on the list in `terraform.tfvars`.

### 2. Auto-Naming
We use **interpolation** to standardize names. For example, `plan_name = "asp-${each.value.name}"` ensures that all service plans follow the naming convention without the user having to type it.

### 3. Decoupling
*   **Modules:** Contain "How" to build.
*   **Tfvars:** Contains "What" to build.
*   **Main:** Acts as the bridge between the two.
