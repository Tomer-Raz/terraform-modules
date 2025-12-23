variable "resource_groups" {
  description = "Map of resource groups to create"
  type = map(object({
    rg_location = string
    rg_tags     = map(string)
  }))
}
variable "management_group_data" {
  type = any
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


variable "subscription_details" {
  type = any
}

variable "tags" {
  type = any
}

variable "resource_type" {
  description = "The type of the Azure resource being monitored"
  type        = string
}

variable "target_id" {
  description = "The ID of the resource to apply diagnostics to"
  type        = string
}

variable "secmon_law_id" {
  description = "Log Analytics Workspace ID for security monitoring"
  type        = string
}

variable "opsmon_law_id" {
  description = "Log Analytics Workspace ID for operational monitoring"
  type        = string
}
