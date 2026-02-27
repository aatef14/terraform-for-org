variable "app_service_plan_name" {
  type = string
}

variable "app_service_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "docker_image_name" {
  type = string
}

variable "zone_balancing_enabled" {
  type = bool
}
