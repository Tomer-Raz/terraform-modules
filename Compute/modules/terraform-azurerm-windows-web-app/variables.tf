variable "service_plan_list" {
  type = map(object({
    resource_group_name = string
    sku_name            = string
    os_type             = string
  }))
}

variable "web_app_list" {
  type = map(object({
    resource_group_name = string
    web_app_name        = string
  }))
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "site_config" {
  type = object({
    always_on        = bool
    app_command_line = string
  })
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