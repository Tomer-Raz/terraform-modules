
output "firewall_policy_id" {
  value = azurerm_firewall_policy.fw_policy.id
}

output "firewall_id" {
  value = azurerm_firewall.fw.id
}


output "vpngw_id" {
  value = azurerm_virtual_network_gateway.vpngw.id
}

output "local_network_gateway_ids" {
  value = { for name, lgw in azurerm_local_network_gateway.localgws : name => lgw.id }
}

output "vpngw_connection_ids" {
  value = { for name, conn in azurerm_virtual_network_gateway_connection.vpngw_connection : name => conn.id }
}


output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}

output "fw_route_table_id" {
  value = azurerm_route_table.fw_rt.id
}

output "vpngw_route_table_id" {
  value = azurerm_route_table.vpngw_rt.id
}

output "hub_subnet_ids" {
  value = [for subnet_name, _ in var.hub.hub_subnets : azurerm_subnet.subnets[subnet_name].id]
}

output "fw_subnet_association_id" {
  value = azurerm_subnet_route_table_association.fw_subnet_association.id
}

output "vpngw_subnet_association_id" {
  value = azurerm_subnet_route_table_association.vpngw_subnet_association.id
}
