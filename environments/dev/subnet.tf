
locals {
  # Map of subnet keys to their actual resource IDs
  # This avoids hardcoding subnet IDs in module blocks
  subnets_lookup = {
    pep_qc   = module.subnets_qc["pep"].subnet_id
    fend_qc  = module.subnets_qc["frontend"].subnet_id
    bend_qc  = module.subnets_qc["backend"].subnet_id
    pep_sc   = module.subnets_sc["pep"].subnet_id
    logic_sc = module.subnets_sc["logic"].subnet_id
    func_sc  = module.subnets_sc["func"].subnet_id
  }
}



################################## START OF SUBNET FILE ####################################################

# Subnet Config

# If you want to add subnet to any VNet, you must add it to the locals.qc_subnets or locals.sc_subnets map.
# eg. if you add a new subnet called "new_subnet", you must add it to the locals.qc_subnets map like this:
# new_subnet = {
#   name      = var.new_subnet_name
#   prefix    = var.new_subnet_prefix
#   vnet_name = module.vnets["qc"].vnet_name
#   delegation = {
#     name    = "web-delegation"
#     service = "Microsoft.Web/serverFarms"
#   }
# }



# Local block for Subnets
locals {

  qc_subnets = {
    # To add more subnets, copy the block below and modify the values
    pep = {
      name      = "snet-pep-qe-qisp-dev-qc-01"
      prefix    = ["10.0.0.0/27"]
      vnet_name = module.vnets["qc"].vnet_name
    }

    frontend = {
      name      = "snet-app-frontend-qe-qisp-stg-qc-01"
      prefix    = ["10.0.0.32/28"]
      vnet_name = module.vnets["qc"].vnet_name

      delegation = {
        name    = "web-delegation"
        service = "Microsoft.Web/serverFarms"
      }
    }

    backend = {
      name      = "snet-app-backend-qe-qisp-stg-qc-01"
      prefix    = ["10.0.0.48/28"]
      vnet_name = module.vnets["qc"].vnet_name
    }

  }

}


module "subnets_qc" {

  for_each = local.qc_subnets
  source   = "../../modules/subnet"

  subnet_name         = each.value.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = each.value.vnet_name
  address_prefixes    = each.value.prefix

  delegation = try(each.value.delegation, null)
  depends_on = [module.vnets]
  # Code Explaination - if exists delegation then use it else null
}


# Local block for Sweden Central Subnets
locals {

  sc_subnets = {
    pep = {
      name      = "snet-pep-qe-qisp-dev-sc-01"
      prefix    = ["10.0.0.0/27"]
      vnet_name = module.vnets["sc"].vnet_name
    }

    logic = {
      name      = "snet-logic-qe-qisp-dev-sc-01"
      prefix    = ["10.0.0.32/28"]
      vnet_name = module.vnets["sc"].vnet_name
    }

    func = {
      name      = var.subnet_func_sc_name
      prefix    = var.subnet_func_sc_prefix
      vnet_name = module.vnets["sc"].vnet_name
    }
  }

}

module "subnets_sc" {
  for_each = local.sc_subnets
  source   = "../../modules/subnet"

  subnet_name         = each.value.name
  resource_group_name = data.azurerm_resource_group.rg_dev.name
  vnet_name           = each.value.vnet_name
  address_prefixes    = each.value.prefix

  depends_on = [module.vnets]
}



################################## END OF SUBNET FILE ####################################################