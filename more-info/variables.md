# Terraform Variables & Scalability Guide

This document explains the variable architecture of this project, focusing on how we use `for_each`, `locals`, and maps to create a scalable and safe infrastructure.

## 🔄 Variable Flow

The project follows a standard 3-step data flow:

1.  **Declaration (`variables.tf`)**: We define the *shape* of the data (types, defaults, and descriptions). We use complex types like `map(object({...}))` to handle multiple resources.
2.  **Assignment (`terraform.tfvars`)**: This is where you provide the actual values. It is the only file you usually need to edit to add or remove resources.
3.  **Implementation (`main.tf`)**: Values are passed into modules. We use iteration logic (`for_each`) to provision resources dynamically based on your assignments.

---

## 🚀 Why `for_each` instead of `count`?

In standard Terraform, `count` creates a **list** of resources, while `for_each` creates a **map**.

### The Problem with Indexing (`count`)
If you use `count`, resources are indexed by numbers (`[0]`, `[1]`, `[2]`). If you have two apps and delete the first one, Terraform will "shift" the second app into the index `[0]`. This causes Terraform to **destroy and recreate** resources that you didn't intend to change.

### The Solution: Name-Based Access (`for_each`)
By using `for_each`, every resource has a unique **Identity (Key)**.
- **Accessing by Name**: You call them by their key, e.g., `module.app_service["fend"]`.
- **Safety**: Adding or removing items in the middle of a map does not affect other items.
- **Predictability**: You always know exactly which resource you are referencing without counting positions.

---

## 🕸️ VNet Integration using `locals`

We use a special `locals` block in `subnet.tf` to manage VNet integration safely.

### The `subnets_lookup` Map
We created a local map that connects human-readable keys to actual Subnet Resource IDs:
```hcl
locals {
  subnets_lookup = {
    pep_qc   = module.subnets_qc["pep"].subnet_id
    fend_qc  = module.subnets_qc["frontend"].subnet_id
    # ...
  }
}
```

### Why use this pattern?
1.  **Dynamic Lookup**: In `main.tf`, you can just provide a `subnet_key = "fend_qc"`. The code automatically looks up the correct ID from the map.
2.  **Decoupling**: The main modules don't need to know the complex internal names of the subnet modules. They only need the key.
3.  **Environment Agility**: It makes it extremely easy to move a Web App or Function from one subnet to another just by changing a single string in `terraform.tfvars`.

---

## 💡 Best Practices to Remember

- **Avoid Hardcoding**: Never hardcode indices like `[0]`. Always aim for named keys.
- **Feature Toggles**: Use the `feature_toggles` map in `terraform.tfvars` to enable/disable entire modules without deleting code.
- **Optional Fields**: We use `optional()` in variable definitions to allow you to skip certain settings (like `docker_image_name`) while still having sensible defaults.
