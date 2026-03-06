# Networking resources for Dev environment
# This file manages VNet and Subnets separately for granular control
locals {
  # Map of subnet keys to their actual resource IDs
  # This avoids hardcoding subnet IDs in module blocks
  subnets = {
    fend_qc  = module.subnet_fend_qc.subnet_id
    bend_qc  = module.subnet_bend_qc.subnet_id
    apim_qc  = module.subnet_apim_qc.subnet_id
    pep_qc   = module.subnet_pep_qc.subnet_id
    pep_sc   = module.subnet_pep_sc.subnet_id
    logic_sc = module.subnet_logic_sc.subnet_id
    func_sc  = module.subnet_func_sc.subnet_id
  }
}

# VNET Config
# VNET_Qatar_Central
module "vnet_qc" {
  source = "../../modules/vnet"

  vnet_name           = var.vnet_name_qc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = var.location_qc
  address_space       = var.vnet_address_space_qc
  tags                = local.common_tags
}
# Subnets for VNET_Qatar_Central
module "subnet_pep_qc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_pep_qc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_qc.vnet_name
  address_prefixes    = var.subnet_pep_qc_prefix

  depends_on = [module.vnet_qc]
}

module "subnet_fend_qc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_fend_qc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_qc.vnet_name
  address_prefixes    = var.subnet_fend_qc_prefix

  depends_on = [module.vnet_qc]
}

module "subnet_bend_qc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_bend_qc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_qc.vnet_name
  address_prefixes    = var.subnet_bend_qc_prefix

  depends_on = [module.vnet_qc]
}

module "subnet_apim_qc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_apim_qc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_qc.vnet_name
  address_prefixes    = var.subnet_apim_qc_prefix

  depends_on = [module.vnet_qc]
}




# VNET_Sweden_Central
module "vnet_sc" {
  source = "../../modules/vnet"

  vnet_name           = var.vnet_name_sc
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = var.location_sc
  address_space       = var.vnet_address_space_sc
  tags                = local.common_tags
}
# Subnets for VNET_Sweden_Central

module "subnet_pep_sc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_pep_sc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_sc.vnet_name
  address_prefixes    = var.subnet_pep_sc_prefix

  depends_on = [module.vnet_sc]
}

module "subnet_logic_sc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_logic_sc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_sc.vnet_name
  address_prefixes    = var.subnet_logic_sc_prefix

  depends_on = [module.vnet_sc]
}

module "subnet_func_sc" {
  source = "../../modules/subnet"

  subnet_name         = var.subnet_func_sc_name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = module.vnet_sc.vnet_name
  address_prefixes    = var.subnet_func_sc_prefix

  depends_on = [module.vnet_sc]
}

