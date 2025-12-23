variable "cognitive_services_settings" {
  description = "Map of resource clu details"
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    kind                          = string
    sku_name                      = string
    public_network_access_enabled = string
    custom_subdomain_name         = string
    local_auth_enabled            = bool
    }
  ))
  default = {}
}

variable "name_convention" {
  description = "updated naming convention"
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}


