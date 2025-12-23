variable "vnets" {
  description = "Map of virtual networks configuration"
  type = map(object({
    address_space  = list(string)
    location       = string
    dns_servers    = list(string)
    hub_vnet_id    = string
    hub_vnet_rg    = string
    hub_vnet_name  = string
  }))
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

variable "resource_group_name" {
  type = string
}