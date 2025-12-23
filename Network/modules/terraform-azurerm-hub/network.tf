locals {
  # Default public IPs
  default_pips = {
    "fw_pip"     = { name = "fw-pip" }
    "vpngw_pip1" = { name = "vpngw-pip-1" }
    "vpngw_pip2" = { name = "vpngw-pip-2" }
  }
  
  # Additional firewall public IPs from module input
  additional_fw_pips = {
    for name in var.additional_fw_pips :
    name => { name = name }
  }

  # Combine all public IPs
  all_pips = merge(local.default_pips, local.additional_fw_pips)

  # All firewall PIPs (default fw_pip + additional)
  fw_pips = merge(
    { "fw_pip" = local.default_pips["fw_pip"] },
    local.additional_fw_pips
  )
}

resource "azurerm_public_ip" "public_ips" {
  for_each = local.all_pips

  name                = "${local.naming_prefix}-${each.value.name}-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  
  lifecycle {
    ignore_changes = [
      tags 
    ]
  }
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-aznt-aznt-hub-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = var.hub.hub_vnet_address_space
  dns_servers         = var.hub.dns_servers

  tags = {
    system_code = "AZNT"
  }
}


### Route Tables ###
resource "azurerm_route_table" "fw_rt" {
  name                          = "${local.naming_prefix}-fw-rt"
  location                      = azurerm_resource_group.hub_rg.location
  resource_group_name           = azurerm_resource_group.hub_rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route_to_internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
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




resource "azurerm_route_table" "vpngw_rt" {
  name                          = "${local.naming_prefix}-vpngw-rt"
  location                      = azurerm_resource_group.hub_rg.location
  resource_group_name           = azurerm_resource_group.hub_rg.name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = var.hub.vpngw_rt_routes
    content {
      name                   = route.value.routeName
      address_prefix         = route.value.routeAddressPrefix
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.hub.fw_private_ip_address
    }
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



resource "azurerm_subnet" "subnets" {
  for_each = var.hub.hub_subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [each.value.subnetNamePrefix]

  lifecycle {
    ignore_changes = [
      address_prefixes
    ]
  }
}

resource "azurerm_subnet_route_table_association" "fw_subnet_association" {
  subnet_id      = azurerm_subnet.subnets["AzureFirewallSubnet"].id
  route_table_id = azurerm_route_table.fw_rt.id
  depends_on = [ azurerm_route_table.fw_rt, azurerm_subnet.subnets ]

}

resource "azurerm_subnet_route_table_association" "vpngw_subnet_association" {
  subnet_id      = azurerm_subnet.subnets["GatewaySubnet"].id
  route_table_id = azurerm_route_table.vpngw_rt.id
  depends_on = [ azurerm_route_table.vpngw_rt, azurerm_subnet.subnets ]
  timeouts {
    create = "60m"
  }
}


output "azureFirewallSubnetIds" {
  value = [for subnet_name, subnet in var.hub.hub_subnets : azurerm_subnet.subnets[subnet_name].id]
}





