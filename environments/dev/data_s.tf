
# For Exisiting Resource group
data "azurerm_resource_group" "rg_dev" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "rg_test" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "rg_prod" {
  name = var.resource_group_name
}