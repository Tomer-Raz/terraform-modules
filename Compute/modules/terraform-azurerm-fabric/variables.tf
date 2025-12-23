variable "config" {
  type = map(object({
    tags           = map(string)
    sku            = string
    admin_emails   = list(string)
  }))
  description = "Configuration for the fabric module."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group id."
}

variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "name_convention" {
  description = "Naming convention details."
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}