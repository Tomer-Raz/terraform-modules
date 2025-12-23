variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
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

variable "kv_details" {
  description = "The Key Vault configuration"
  type = map(object({
    enabled_for_disk_encryption   = bool
    soft_delete_retention_days    = number
    purge_protection_enabled      = bool
    public_network_access_enabled = bool
    enable_rbac_authorization     = bool
    sku_name                      = string
    tags                          = map(string)
    bypass                        = string
  }))
}

variable "kv_global_admins" {
  type = map(string)
}

variable "service_principal_permissions" {
  description = "Route table configuration"
  type = map(object({
    target_kv = string
    object_id = string
    key_permissions   = list(string)
    secret_permissions   = list(string)
    storage_permissions   = list(string)
    certificate_permissions   = list(string)
  }))
  default = null
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}



