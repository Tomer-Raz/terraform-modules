variable "event_grid_namespace_setting"{
          type = map(object({
            name=string
            location=string
            capacity = optional(number) 
            public_network_access =optional(string)
            identity_type =string
            sku=optional(string)
            topic_spaces_configurati_maximum_session_expiry_in_hours =optional(number)  

          }))
}

variable "resource_group" {
  type = string
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

variable "secmon_law_id" {
  type = string
}

variable "opsmon_law_id" {
  type = string
}