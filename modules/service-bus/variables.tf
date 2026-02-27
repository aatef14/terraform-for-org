variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "capacity" {
  type = number
}

variable "sbus_sku_name" {
  type = string
}

variable "premium_messaging_partitions" {
  type = number
}
