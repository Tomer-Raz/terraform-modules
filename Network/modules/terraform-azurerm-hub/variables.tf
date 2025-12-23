variable "hub" {
  description = "Hub configuration"
  type = object({
    location               = string
    hub_vnet_address_space = list(string)
    dns_servers            = list(any)
    hub_subnets            = map(object({
      subnetName           = string
      subnetNamePrefix     = string
      routeTableNameSuffix = string
    }))
    fw_private_ip_address  = string
    vpngw_rt_routes        = list(object({
      routeName          = string
      routeAddressPrefix = string
    }))
    vpngw_bgp_asn          = number
    localgw_networks       = map(object({
      local_gateway_address = string
      local_address_space   = list(string)
    }))
    localgw_bgp_settings   = map(object({
      asn_number     = number
      peering_address = string
    }))
    fw_tags                = map(string)
    fw_policy_tags         = map(string)
    log_analytics_workspace_id = string
    log_analytics_workspace_id_sec = string
  })

}

variable "name_convention" {
  type = object({
      region                   = string
      name = string
      env                      = string
      cmdb_infra               = string
      cmdb_project             = string
    })
}

variable "additional_fw_pips" {
  description = "List of additional firewall public IP names."
  type        = list(string)
  default     = []
}

variable "shared_key" {
  type = string
}
