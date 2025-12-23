resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = "${local.name_prefix}-${each.key}-vnet"
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = var.resource_group_name
  dns_servers         = each.value.dns_servers
  provider            = azurerm.spoke
}

resource "azurerm_virtual_network_peering" "spoke_to_hub_vnet_peering" {
  for_each = var.vnets

  name                      = "peer-${local.name_prefix}-${each.key}-to-hub-vnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = "${local.name_prefix}-${each.key}-vnet"
  remote_virtual_network_id = each.value.hub_vnet_id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
  provider                  = azurerm.spoke

  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke_vnet_peering" {
  for_each = var.vnets

  name                      = "peer_hub-vnet-to-${local.name_prefix}-${each.key}"
  resource_group_name       = each.value.hub_vnet_rg
  virtual_network_name      = each.value.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.key].id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  provider                  = azurerm.hub

  depends_on = [azurerm_virtual_network.vnet]
}
