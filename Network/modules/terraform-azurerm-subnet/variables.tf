variable "resource_group_name" {
  type = string
}

variable "name_convention" {
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    address_prefixes = list(string)
    delegation = optional(object({
      name         = optional(string)
      service_name = optional(string)
      actions      = optional(list(string))
    }), null)
    virtual_network_name = string
  }))
}

variable "route_tables" {
  description = "Route table configuration"
  type = map(object({
    location = string
    routes = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
  default = null
}

variable "associations" {
  type = map(object({
    subnet_name      = string
    route_table_name = string
  }))
  default = null
}
