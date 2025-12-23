variable "workspaces" {
  description = "Map of Log Analytics Workspaces to create"
  type = map(any)
}

variable "name_convention" {
  description = "Naming convention details"
  type = object({
    region                   = string
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