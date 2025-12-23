resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = "${local.naming_prefix}-vpngw"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw2AZ"

  bgp_settings {
    asn = var.hub.vpngw_bgp_asn
  }

  ip_configuration {
   name                 = azurerm_public_ip.public_ips["vpngw_pip1"].name
   public_ip_address_id = azurerm_public_ip.public_ips["vpngw_pip1"].id
   subnet_id            = azurerm_subnet.subnets["GatewaySubnet"].id
  }

  ip_configuration {
    name                 = azurerm_public_ip.public_ips["vpngw_pip2"].name
    public_ip_address_id = azurerm_public_ip.public_ips["vpngw_pip2"].id
    subnet_id            = azurerm_subnet.subnets["GatewaySubnet"].id
  }

  depends_on = [
    azurerm_public_ip.public_ips,
    azurerm_virtual_network.hub_vnet,
    azurerm_subnet.subnets
  ]

  lifecycle {
    ignore_changes = [
      tags 
    ]
  }
}

### Local Network Gateways ###
resource "azurerm_local_network_gateway" "localgws" {
  for_each = var.hub.localgw_networks

  name                = "${local.naming_prefix}-localgw-${each.key}"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  gateway_address     = each.value.local_gateway_address
  address_space       = each.value.local_address_space

  bgp_settings {
    asn                 = var.hub.localgw_bgp_settings[each.key].asn_number
    bgp_peering_address = var.hub.localgw_bgp_settings[each.key].peering_address
  }

  tags = {
    system_code = "AZNT"
  }

  lifecycle {
    ignore_changes = [
    tags
    ]
  }
}

### Virtual Network Gateway Connection ###
resource "azurerm_virtual_network_gateway_connection" "vpngw_connection" {
  for_each = var.hub.localgw_networks

  name                       = "${local.naming_prefix}-vpngw-conn-${each.key}"
  location                   = azurerm_resource_group.hub_rg.location
  resource_group_name        = azurerm_resource_group.hub_rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.localgws[each.key].id
  shared_key                 = var.shared_key
  connection_protocol        = "IKEv2"

  enable_bgp = true

  ipsec_policy {
    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA1"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA1"
    pfs_group        = "None"
    sa_datasize      = 4608000
    sa_lifetime      = 3600
  }

  lifecycle {
    ignore_changes = [
     tags
    ]
  }
}
