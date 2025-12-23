variable "resource_group_name" {
  type        = string
  description = "description"
}

variable "location" {
  type        = string
  description = "description"
}

variable "synapse_name" {
  type        = string
  description = "description"
}

variable "datalake_id" {
  type        = any
  description = "description"
}

variable "key_vault_id" {
  type        = any
  description = "description"
}

variable "kv_key_versionless_id" {
  type        = string
  description = "description"
}

variable "login_group_name" {
  type = string
}

variable "aad_admin_object_id" {
  type = string
}

variable "env" {
  type = string
}

variable "targetScope" {
  type = string
}

variable "key_name" {
  type = string
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

variable "prvtlnk_pe_details" {
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

variable "mng_pe_details" {
  description = "The Private EndPoint configuration"
  type = map(object({
    subresource_name = string
  }))
}


variable "synapse_rbac_details" {
  type = map(object({
      role_name            = string
      principal_id         = string
}))
  description = "Names and address prefixes of the subnets to create"
  default     = null
}

variable "mng_pe" {
  type = list(
    object({
      mng_pe_name                  = string
      mngpe_subresource_name       = string
      }
    )
  )
  description = "Names and address prefixes of the subnets to create"
  default     = null
}

variable "target_resource_id" {
  type = any
}

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}

variable "create_additional_spark_pool" {
  type  =  bool
  default = false
  description = "Controls whether to create as additional Spark 3.4 pool"
}

# variable "spark_version" {
#   type = string
#   description = "The version of Spark to use in the synapse Spark Pool"
# }

# variable "spark_pools" {
#   description = "Map of Spark pools to create"
#   type = map(object({
#     node_size_family = string
#     node_size        = string
#     cache_size       = number
#     spark_version    = string
#     max_node_count   = number
#     min_node_count   = number
#     delay_in_minutes = number
#     library_requirement = object({
#       content  = string
#       filename = string
#     })
#     spark_config = object({
#       content  = string
#       filename = string
#     })
#   }))  
# }

