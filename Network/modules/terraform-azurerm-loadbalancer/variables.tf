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

variable "resource_group_name" {
  description = "rg name"
  type        = string
}

variable "load_balancers_details" {
  type = object({
    load_balancers = map(object({
      # name                           = string
      location                       = string
      sku                            = string
      frontend_ip_configuration_name = string
      subnet_id                      = string
      private_ip_address             = string
      private_ip_address_allocation  = string
    }))
    lb_backend_address_pool = map(object({
      load_balancer_key_name = string
    }))
    lb_backend_address_pool_address = map(object({
      load_balancer_key_name = string
      virtual_network_id     = string
      ip_address             = string
      address_pool           = string
    }))
    lb_probe = map(object({
      load_balancer_key_name = string
      protocol               = string
      port                   = number
      probe_threshold        = number
      interval_in_seconds    = number
      number_of_probes       = number
      request_path           = string
    }))
    lb_rules = map(any)
  })
}
