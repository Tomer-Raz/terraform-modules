variable "diagnostic_setting" {
  description = "List of diagnostic settings to create"
  type = list(object({
    name               = string
    target_resource_id = string
    type               = string
    law_id             = any
    enabled_logs = list(object({
      category = string
    }))
    metrics = list(object({
      category = string
    }))
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