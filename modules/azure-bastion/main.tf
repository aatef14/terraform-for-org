resource "azurerm_public_ip" "example" {
  name                = var.azure_bastion_pip_name
  location            = var.azure_bastion_location
  resource_group_name = var.azure_bastion_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = var.azure_bastion_name
  location            = var.azure_bastion_location
  resource_group_name = var.azure_bastion_resource_group_name
  sku                 = var.azure_bastion_sku
  scale_units         = var.azure_bastion_scale_units
  ip_configuration {
    name                 = var.azure_bastion_pip_name
    subnet_id            = var.azure_bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}
