variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "service_plan_list" {
  description = "A map of service plans to create"
  type = map(object({
    resource_group_name = string
    os_type             = string
    sku_name            = string
  }))
}

variable "application_insights_settings" {
  description = "Settings for Application Insights instances"
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    application_type              = string
    daily_data_cap_in_gb          = number
    retention_in_days             = number
    workspace_id                  = string
    local_authentication_disabled = bool
    internet_ingestion_enabled    = bool
    internet_query_enabled        = bool
  }))
}

variable "service_plan_list" {
  type = any
}

variable "name_convention" {
  type = any
}

variable "private_dns_zone_data" {
  type = any
}

variable "cognitive_services_settings" {
  description = "Settings for Cognitive Services accounts"
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    kind                          = string
    sku_name                      = string
    public_network_access_enabled = bool
    custom_subdomain_name         = string
    local_auth_enabled            = bool
  }))
}

variable "namespaces" {
  description = "EventHub namespaces to create"
  type = map(object({
    name                          = string
    location                      = string
    sku                           = string
    capacity                      = number
    auto_inflate_enabled          = bool
    maximum_throughput_units      = number
    public_network_access_enabled = bool
  }))
}

variable "eventhubs" {
  description = "EventHubs to create"
  type = map(object({
    name                = string
    namespace_name      = string
    partitions          = number
    message_retention   = number
    capture_enabled     = bool
    capture_encoding    = string
    blob_container_name = string
    storage_account_id  = string
  }))
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "keyvaults" {
  description = "Key Vaults to create"
  type = map(object({
    location                      = string
    resource_group_name           = string
    tenant_id                     = string
    sku_name                      = string
    public_network_access_enabled = bool
  }))
}

variable "access_policies" {
  description = "Access policies for Key Vaults"
  type = map(object({
    key_vault_id            = string
    tenant_id               = string
    object_id               = string
    application_id          = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
}

variable "linux_function_app_list" {
  description = "List of Linux Function Apps to create"
  type = map(object({
    name                       = string
    resource_group_name        = string
    service_plan_id            = string
    storage_account_name       = string
    storage_account_access_key = string
  }))
}

variable "windows_function_app_list" {
  description = "List of Windows Function Apps to create"
  type = map(object({
    name                       = string
    resource_group_name        = string
    service_plan_id            = string
    storage_account_name       = string
    storage_account_access_key = string
  }))
}

variable "web_app_list" {
  description = "List of Web Apps to create"
  type = map(object({
    web_app_name        = string
    resource_group_name = string
  }))
}

variable "site_config" {
  description = "Site configuration for function apps and web apps"
  type = object({
    always_on        = bool
    app_command_line = string
  })
}

variable "workspaces" {
  description = "Log Analytics Workspaces to create"
  type = map(object({
    law_name                   = string
    rg_location                = string
    rg_name                    = string
    sku                        = string
    retention_in_days          = number
    internet_ingestion_enabled = bool
    internet_query_enabled     = bool
    tags                       = map(string)
  }))
}

variable "management_group_data" {
  description = "JSON file path for management group data"
  type        = string
}

variable "private_dns_zone_data" {
  description = "JSON file path for private DNS zone data"
  type        = string
}

variable "private_dns_zone_link_data" {
  description = "JSON file path for private DNS zone link data"
  type        = string
}


variable "resource_group" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the storage account."
  type        = string
}


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
    public_network_access_enabled   = bool
    allow_nested_items_to_be_public = bool
    bypass                          = list(string)
    containers = list(object({
      name        = string
      access_type = string
    }))
  }))
  description = "Map of storage accounts and their configurations, including containers"
}


variable "keyvaults" {

}
