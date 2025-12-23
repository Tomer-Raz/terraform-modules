variable "acs_resources" {
  description = "Map of ACS configurations"
  type = map(object({
    data_location       = string
  }))
}

variable "resource_group" {
  description = "Resource group name"
  type = string
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

variable "secmon_law_id" {
  description = "The ID of the Security Monitoring Law."
  type = string
}

variable "opsmon_law_id" {
  description = "The ID of the Operations Monitoring Law."
  type = string
}