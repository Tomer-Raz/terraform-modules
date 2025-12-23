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
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}

variable "pe_details" {
  description = "The Private EndPoint configuration"
  type = map(object({
    ip_configuration = optional(object({
      name               = string
      private_ip_address = string
      subresource_name   = string
      member_name        = string
    }))
    ip_configurations = optional(list(object({
      name               = string
      private_ip_address = string
      subresource_name   = string
      member_name        = string
    })))
    subnet_id = string
    private_service_connection = object({
      name                 = string
      is_manual_connection = bool
      subresource_names    = list(string)
    })
    private_dns_zone_names  = list(string)
    destination_resource_id = string
  }))
}


variable "private_dns_zones" {
  description = "the output of the private dns zones tf workspace"
  type        = map(string)
}




