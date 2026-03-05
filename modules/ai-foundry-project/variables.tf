variable "name" {
  description = "Name of the AI Foundry Project"
  type        = string
}

variable "hub_id" {
  description = "ID of the AI Foundry Hub"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
