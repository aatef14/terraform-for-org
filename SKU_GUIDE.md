# Azure Resource SKU Quick Reference

This guide provides a quick reference for the SKUs and tiers available for the resources used in this Terraform project. Use this as a cheat sheet when updating `terraform.tfvars` or module variables.

---

## 🌐 App Service Plans (Web Apps)

The `sku_name` determines the performance and features for your Standard Web Apps.

| Sr No | SKU Name | Tier | Ideal For | Features |
| :--- | :--- | :--- | :--- | :--- |
| 1 | **F1** | Free | Development/Testing | Shared infrastructure, 1GB RAM. |
| 2 | **B1** | Basic | Small apps / Dev | Dedicated VMs, 1.75GB RAM. |
| 3 | **S1** | Standard | Production | 1.75GB RAM, Auto-scale, Slots. |
| 4 | **P1v2** | Premium v2 | High Performance | Faster CPUs, SSD, VNet inclusion. |
| 5 | **P1v3** | Premium v3 | Next-Gen Perf | Latest hardware, high memory. |

---

## 🚀 Function App Plans

Specific plans optimized for Serverless and Event-driven scaling.

| Sr No | SKU Name | Tier | Ideal For | Features |
| :--- | :--- | :--- | :--- | :--- |
| 1 | **Y1** | Consumption | True Serverless | Pay-per-execution, scales to zero. |
| 2 | **EP1** | Premium Elastic | High Performance | Pre-warmed instances, VNet. |
| 3 | **EP2** | Premium Elastic | High Performance | More CPU/RAM than EP1. |
| 4 | **EP3** | Premium Elastic | High Performance | Maximum Elastic performance. |

---

## 🗄️ Storage Account

| Sr No | Category | Options | Description |
| :--- | :--- | :--- | :--- |
| 1 | **Tier** | `Standard`, `Premium` | Standard (HDD/SSD) vs Premium (SSD). |
| 2 | **Replication** | `LRS`, `GRS`, `ZRS`, `GZRS` | Local, Geo, Zone, or Geo-Zone redundancy. |
| 3 | **Kind** | `StorageV2`, `FileStorage` | General Purpose v2 or Premium Files. |

---

## ⚡ API Management (APIM)

| Sr No | SKU Name | Target Use Case | Features |
| :--- | :--- | :--- | :--- |
| 1 | **Consumption**| Serverless | Pay-per-call, instant scaling. |
| 2 | **Developer** | Dev/Test | Full features but No SLA. |
| 3 | **Basic** | Small Production | 2 Units max, basics. |
| 4 | **Standard** | Mid-scale Prod | 4 Units, AD Integration. |
| 5 | **Premium** | Enterprise | Multi-region, VNet, HA. |

---

## 🚌 Service Bus

| Sr No | SKU Name | Tier | Key Differences |
| :--- | :--- | :--- | :--- |
| 1 | **Basic** | Basic | Queues only, 256KB max message. |
| 2 | **Standard** | Standard | Topics, 256KB max message, No VPC. |
| 3 | **Premium** | Premium | Dedicated resources, 1MB+ message. |

---

## 🐘 PostgreSQL (Flexible Server)

SKUs are formatted as `[Tier]_[Compute]_[Cores]`.

| Sr No | Tier | Format Example | Description |
| :--- | :--- | :--- | :--- |
| 1 | **Burstable** | `B_Standard_B1ms` | Low cost, variable performance. |
| 2 | **General Purpose** | `GP_Standard_D2s_v3`| Balanced compute/memory. |
| 3 | **Memory Optimized**| `MO_Standard_E2s_v3`| High memory requirements. |

---

## 🧠 Azure Cache for Redis

| Sr No | SKU Name | Family | Description |
| :--- | :--- | :--- | :--- |
| 1 | **Basic** | `C0` - `C6` | Single node, no SLA. |
| 2 | **Standard** | `C0` - `C6` | Two-node Primary/Replica. |
| 3 | **Premium** | `P1` - `P5` | SSD, VNet, Persistence. |

---

## 🎟️ Event Hubs

| Sr No | SKU Name | Tier | Features |
| :--- | :--- | :--- | :--- |
| 1 | **Basic** | Basic | 1 Consumer group, 256KB message. |
| 2 | **Standard** | Standard | 20 Consumer groups, 1MB message. |
| 3 | **Premium** | Premium | High throughput, VNet, Private Link. |

---

## 🔐 Key Vault

| Sr No | SKU Name | Description |
| :--- | :--- | :--- |
| 1 | **standard** | Standard vault (Software-protected). |
| 2 | **premium** | Premium vault (HSM-protected). |
