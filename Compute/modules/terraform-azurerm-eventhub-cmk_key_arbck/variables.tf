variable "namespaces" {
  description = "A map of namespace names and their properties"
  type = map(object({
    name                          = string
    location                      = string
    sku                           = optional(string, "Premium")
    capacity                      = optional(number)
    auto_inflate_enabled          = optional(bool)
    maximum_throughput_units      = optional(number)
    public_network_access_enabled = optional(bool)
    local_authentication_enabled  = optional(bool)
    identity_type       = optional(string)
  }))
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "eventhubs" {
  description = "A map of event hub names and their properties"
  type = map(object({
    name                = string
    namespace_name      = string
    partitions          = number
    message_retention   = number
    special_cmdb        = optional(bool)
    capture_enabled     = optional(bool)
    capture_encoding    = optional(string)
    blob_container_name = optional(string)
    storage_account_id  = optional(string)
    destination_name    = optional(string)
    archive_name_format = optional(string)
  }))
}

variable "consumer_groups" {
  description = "A map of consumer group names and their properties"
  type = map(object({
    name           = string
    eventhub_name  = string
    namespace_name = string
  }))
}

variable "name_convention" {
  description = "updated naming convention"
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
    cmdb_project_special      = optional(string, "")
  })
}

variable "location" {
  type = string
}

# variable "tags" {
#   type        = map(any)
#   description = "value"
# }

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

##to add 03022025
variable "enable_encryption" {
  description = "Enable customer-managed key (CMK) encryption for the Event Hub Namespace"
  type        = bool
  default     = false
}

variable "key_vault_key_ids" {
  description = "A list of Key Vault key IDs to use for encryption"
  type        = list(string)
  default     = []
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault that stores the encryption key"
  type        = string
  default     = null
}

