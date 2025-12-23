variable "application_insights_settings" {
  description = "Map of resource application insinghts details"
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    application_type              = string
    daily_data_cap_in_gb          = optional(number)
    retention_in_days             = optional(number)
    workspace_id                  = string
    local_authentication_disabled = bool
    internet_ingestion_enabled    = bool
    internet_query_enabled        = bool
    }
  ))
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

variable "location" {
  type    = string
}

variable "tags" {
  type = map(string)
}
