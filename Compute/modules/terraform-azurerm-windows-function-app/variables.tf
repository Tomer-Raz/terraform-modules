variable "windows_function_apps" {
  type = map(object({
    name                                   = string
    app_insight_name                       = optional(string)
    resource_group_name                    = string
    application_insights_connection_string = optional(string)
    service_plan_id                        = string
    storage_account_name                   = string
    subnet_id                              = optional(string)
    site_config = object({
      always_on        = bool
      app_command_line = optional(string)
      use_32_bit_worker = optional(bool)
      application_stack = optional(object({
        node_version            = optional(string)
        dotnet_version          = optional(string)
        java_version            = optional(string)
        powershell_core_version = optional(string)
      }))
    })
    app_settings = map(string)
    function = optional(object({
      name        = string
      test_data   = map(string)
      config_json = object({
        bindings = list(object({
          authLevel = optional(string)
          direction = string
          methods   = optional(list(string))
          name      = string
          type      = string
        }))
      })
    }))
  }))
  description = "Configuration for windows Function Apps"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "files" {
    type = any
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

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

