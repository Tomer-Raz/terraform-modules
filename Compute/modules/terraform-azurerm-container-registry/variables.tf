variable "location" {
  description = "Azure region where the container registry will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "name_convention" {
  description = "Naming convention configuration"
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra               = string
    cmdb_project             = string
  })
}

variable "tags" {
  description = "Tags to associate with the container registry"
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "The SKU name of the container registry"
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled"
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "The type of identity used for the container registry"
  type        = string
  default     = "SystemAssigned"
}

variable "georeplications" {
  description = "Configuration for geo-replication of the container registry"
  type = map(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
    tags                    = optional(map(string))
  }))
  default = {}
}