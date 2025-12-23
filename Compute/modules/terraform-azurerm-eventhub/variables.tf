variable "namespaces" {
  description = "A map of namespace names and their properties"
  type = map(object({
    name                          = string
    location                      = string
    sku                           = optional(string, "Standard")
    capacity                      = optional(number)
    auto_inflate_enabled          = optional(bool)
    maximum_throughput_units      = optional(number)
    public_network_access_enabled = optional(bool, false)
    local_authentication_enabled  = optional(bool, true)
    allowed_ips                   = optional(list(string), [])
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

variable "tags" {
  type        = map(any)
  description = "value"
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}
