variable "subscription_details" {
  type = object({
    name                    = string
    billing_account_name    = string
    enrollment_account_name = string
    mgmt_id                 = string
  })
  description = "subscription details"
}

variable "tags" {
  type = object({
    source-organization      = string	
    source-environment	      = string
    source-cmdb-system-code	= string
    source-system-name	      = string
    source-owner	            = optional(string)
    source-department-code	  = optional(string)
    source-department-name   = optional(string)	
    source-planit-project-id = optional(string)
  })
  description = "subscription tags"
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