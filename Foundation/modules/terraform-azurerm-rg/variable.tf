variable "resource_groups" {
  description = "Map of resource group details"
  type = map(object({
    rg_location = string
    rg_tags     = map(string)
  }))
  default = {}
}

variable "name_convention" {
description = "updated naming convention"
  type    = object({
    region                      = string
    name   = string
    env                         = string
    cmdb_infra                  = string
    cmdb_project                = string
  })
}