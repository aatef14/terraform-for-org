variable "azure_bastion_name" {
    type = string
}
variable "azure_bastion_location" {
    type = string
    default = "eastus"
}
variable "azure_bastion_resource_group_name" {
    type = string
    default = "bastion-rg"
}
variable "azure_bastion_sku" {
    type = string
    default = "Standard"
}
variable "azure_bastion_scale_units" {
    type = int
    default = 2
}

variable "azure_bastion_pip_name" {
    type = string
    default = "bastion-pip"
}
variable "azure_bastion_subnet_id" {
    type = string
    default = "bastion-subnet-id"
}

