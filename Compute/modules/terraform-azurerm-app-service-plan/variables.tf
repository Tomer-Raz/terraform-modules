variable "location" {
  type    = string
}

variable "tags" {
  type = map(string)
}

variable "service_plan_list" {
  type = map(object({
    resource_group_name = string
    sku_name            = string
    os_type             = string
    worker_count        = optional(number)
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

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

