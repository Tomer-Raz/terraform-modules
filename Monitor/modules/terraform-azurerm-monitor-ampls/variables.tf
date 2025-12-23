variable "ampls" {
  type = object({
    name                = string
    resource_group_name = string
    scoped_resources = list(object({
      name        = string
      resource_id = string
    }))
  })
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

variable "location" {
  description = "Azure location"
  type        = string
}


variable "private_dns_zones" {
  description = "the output of the private dns zones tf workspace"
  type        = map(string)
}


variable "ampls_pe" {
  type = object({
    pe_details      = any
    name_convention = any
  })
}
