variable "location" {
  description = "Azure region where the container apps will be deployed"
  type        = string
}


variable "name_convention" {
  description = "Naming convention configuration"
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra               = string
    cmdb_project             = string
  })
}

variable "environment_id" {
  description = "ID of the Container Apps Environment"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the container apps"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "container_apps" {
  description = "Configuration for the container apps"
  type = map(object({
    name                  = string
    image                 = string
    cpu                   = number
    memory                = string
    workload_profile_name = optional(string)
    identity_type         = optional(string)
    ephemeral_storage     = optional(string)
    revision_suffix       = optional(string)
    
    registry = optional(map(object({
      server               = string
      username             = string
      password_secret_name = string
    })))

    replicas = optional(object({
      min = optional(number, 1)
      max = optional(number, 1)
    }))

    ingress = optional(object({
      external          = optional(bool, false)
      target_port       = optional(number, 80)
      transport         = optional(string, "auto")
      allow_insecure    = optional(bool, false)
    }))

    environment_variables = optional(map(string))
  }))

  validation {
    condition     = alltrue([for k, v in var.container_apps : can(regex("^[a-zA-Z0-9-]+$", v.name))])
    error_message = "Container app names must only contain alphanumeric characters and hyphens."
  }
}
