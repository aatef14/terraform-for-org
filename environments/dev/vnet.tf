# Networking resources for Dev environment
# This file manages VNet and Subnets separately for granular control


################################### START OF VNET FFILE ####################################################



# VET Config
# Whenever you add a new VNet, you must add it to the locals.vnets map.

# eg. if you add a new VNet called "new_vnet", you must add it to the locals.vnets map like this:
# new_vnet = {
#   name          = var.new_vnet_name
#   location      = var.new_vnet_location
#   address_space = var.new_vnet_address_space
# }


# For subnet config go to subnets.tf

# Local block for VNET
locals {

  vnets = { 
    # To add more VNets, copy the block below and modify the values
    qc = {  # This becomes module.vnets["qc"].vnet_id
      name          = "vnet-qc"
      location      = "qatar"
      address_space = ["10.0.0.0/16"]
    }

    sc = {
      name          = "vnet-sc"
      location      = "sweden"
      address_space = ["10.0.0.0/16"]
    }

  }

}


# VNET Module 
# This will create VNETs based on the local.vnets map
module "vnets" {

  for_each = local.vnets
  source   = "../../modules/vnet"

  vnet_name           = each.value.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  location            = each.value.location
  address_space       = each.value.address_space
  tags                = local.common_tags

}


#################################### END OF VNET FFILE ####################################################

































# # VNET Config
# # VNET_Qatar_Central
# module "vnet_qc" {
#   source = "../../modules/vnet"

#   vnet_name           = var.vnet_name_qc
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   location            = var.location_qc
#   address_space       = var.vnet_address_space_qc
#   tags                = local.common_tags
# }
# # Subnets for VNET_Qatar_Central
# module "subnet_pep_qc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_pep_qc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_qc.vnet_name
#   address_prefixes    = var.subnet_pep_qc_prefix

#   depends_on = [module.vnet_qc]
# }

# module "subnet_fend_qc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_fend_qc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_qc.vnet_name
#   address_prefixes    = var.subnet_fend_qc_prefix

#   depends_on = [module.vnet_qc]
# }

# module "subnet_bend_qc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_bend_qc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_qc.vnet_name
#   address_prefixes    = var.subnet_bend_qc_prefix

#   depends_on = [module.vnet_qc]
# }

# module "subnet_apim_qc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_apim_qc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_qc.vnet_name
#   address_prefixes    = var.subnet_apim_qc_prefix

#   depends_on = [module.vnet_qc]
# }




# # VNET_Sweden_Central
# module "vnet_sc" {
#   source = "../../modules/vnet"

#   vnet_name           = var.vnet_name_sc
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   location            = var.location_sc
#   address_space       = var.vnet_address_space_sc
#   tags                = local.common_tags
# }
# # Subnets for VNET_Sweden_Central

# module "subnet_pep_sc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_pep_sc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_sc.vnet_name
#   address_prefixes    = var.subnet_pep_sc_prefix

#   depends_on = [module.vnet_sc]
# }

# module "subnet_logic_sc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_logic_sc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_sc.vnet_name
#   address_prefixes    = var.subnet_logic_sc_prefix

#   depends_on = [module.vnet_sc]
# }

# module "subnet_func_sc" {
#   source = "../../modules/subnet"

#   subnet_name         = var.subnet_func_sc_name
#   resource_group_name = data.azurerm_resource_group.rg_dev.name
#   vnet_name           = module.vnet_sc.vnet_name
#   address_prefixes    = var.subnet_func_sc_prefix

#   depends_on = [module.vnet_sc]
# }
