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

variable "name_convention" {
  description = "Naming convention details"
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}
