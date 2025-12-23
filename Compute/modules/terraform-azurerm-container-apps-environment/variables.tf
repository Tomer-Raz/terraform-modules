
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

variable "name" {
  description = "Name of the container apps"
  type        = string
  
}

variable "location" {
  description = "Azure region where the environment will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the environment"
  type        = map(string)
}

variable "dapr_enabled" {
  description = "Enable Dapr for the environment"
  type        = bool
}

variable "lb_enabled" {
  description = "LB private"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "subnet id for private"
  type        = string 
  default     = null
}

variable "logs" {
  description = "Log Analytics Workspace configuration"
  type = object({
    log_analytics_workspace_id = string
  })
}