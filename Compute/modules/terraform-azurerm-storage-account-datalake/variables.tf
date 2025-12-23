variable "resource_group_name" {
  type        = string
  description = "description"
}

variable "location" {
  type        = string
  description = "description"
}

variable "kv_key_versionless_id" {
  type        = string
  description = "description"
}


variable "identity_id" {
  type        = string
  description = "description"
}

variable "sa_name" {
  type        = string
  description = "description"
}

variable "subnet_id" {
  type = string
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


variable "pe_details" {
  description = "The Private EndPoint configuration"
  type = map(object({
    ip_configuration = object({
      name               = string
      private_ip_address = string
      subresource_name   = string
      member_name        = string
    })
    private_service_connection = object({
      name                 = string
      is_manual_connection = bool
      subresource_names    = list(string)
    })
    private_dns_zone_group = object({
      private_dns_zone_ids = list(string)
    })
  }))
}

variable "containers_details" {
  description = "The Key Vault configuration"
  type = map(object({
    container_access_type      = string
  }))
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

variable "account_replication_type" {
  type = string
}



