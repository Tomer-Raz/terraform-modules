variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created"
}



variable "storage_accounts" {
  type = map(object({
    name                            = string
    account_tier                    = string
    account_replication_type        = string
    account_kind                    = string
    network_action                  = string
    public_network_access_enabled   = bool
    allow_nested_items_to_be_public = bool
    bypass                          = list(string)
    static_website = optional(object({
      index_document     = string
      error_404_document = string
    }))
    cmk = optional(object({
      key_vault_id = string
      key_name     = string
      key_version  = optional(string)
      tenant_id =string
    }))
  }))
   description = "Map of storage accounts and their configurations, including containers"

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

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

