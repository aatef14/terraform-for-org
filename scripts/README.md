# 🔄 Environment Synchronization Scripts

This directory contains scripts to help developers maintain consistency across different Terraform environments (`dev`, `stg`, `prod`).

## 🎯 Purpose

In a typical development workflow, changes are first implemented and tested in the `dev` environment. Once the configuration is stable, those same Terraform files need to be promoted to `stg` (Staging) and `prod` (Production).

These scripts automate the process of copying `*.tf` and `*.tfvars` files from `environments/dev` to the other environment folders, ensuring that all environments share the same logic and structure.

> [!IMPORTANT]
> These scripts facilitate **development consistency**. They ensure that when you refactor a module or add a new variable in `dev`, you don't forget to update `stg` or `prod`.

---

## 💻 Available Scripts

### 1. Windows (PowerShell)
**File**: `sync_environments.ps1`
**How to use**:
1. Open PowerShell.
2. Navigate to the `scripts` directory.
3. Run: `.\sync_environments.ps1`

### 2. Linux / macOS (Bash)
**File**: `sync_environments.sh`
**How to use**:
1. Open a terminal.
2. Navigate to the `scripts` directory.
3. Make the script executable (first time only): `chmod +x sync_environments.sh`
4. Run: `./sync_environments.sh`

---

## 🛠️ What the scripts do

1.  Identify `environments/dev` as the source of truth.
2.  Target `environments/stg` and `environments/prod`.
3.  Copy all files matching `*.tf` (Terraform logic).
4.  Copy all files matching `*.tfvars` (Variable assignments).
5.  Overwrite existing files in target directories to match the `dev` state.

## 💡 Best Practices

*   **Regional Differences**: After running the script, you might need to manually adjust specific values in `terraform.tfvars` if your `stg` or `prod` environments use different regions or subscription IDs.
*   **Version Control**: Always review the changes made by the script using `git status` or `git diff` before committing.
