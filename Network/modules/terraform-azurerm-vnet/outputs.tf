output "virtual_networks" {
  description = "The virtual network configurations"
  value = {
    for vnet_key, vnet_value in azurerm_virtual_network.vnet : vnet_key => {
      id             = vnet_value.id
      name           = vnet_value.name
      address_space  = vnet_value.address_space
      location       = vnet_value.location
      resource_group = vnet_value.resource_group_name
      dns_servers    = vnet_value.dns_servers
    }
  }
}

output "spoke_to_hub_vnet_peerings" {
  description = "The spoke-to-hub virtual network peerings"
  value = {
    for peering_key, peering_value in azurerm_virtual_network_peering.spoke_to_hub_vnet_peering : peering_key => {
      name                    = peering_value.name
      remote_virtual_network  = peering_value.remote_virtual_network_id
      allow_forwarded_traffic = peering_value.allow_forwarded_traffic
    }
  }
}

output "hub_to_spoke_vnet_peerings" {
  description = "The hub-to-spoke virtual network peerings"
  value = {
    for peering_key, peering_value in azurerm_virtual_network_peering.hub_to_spoke_vnet_peering : peering_key => {
      name                   = peering_value.name
      remote_virtual_network = peering_value.remote_virtual_network_id
    }
  }
}
