output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for k, v in azurerm_subnet.subnet : k => v.id
  }
}

output "route_table_ids" {
  description = "Map of route table names to their IDs"
  value = {
    for k, v in azurerm_route_table.route_tables : k => v.id
  }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value = {
    for k, v in azurerm_subnet.subnet : k => v.address_prefixes
  }
}

output "route_table_routes" {
  description = "Map of route table names to their routes"
  value = {
    for k, v in azurerm_route_table.route_tables : k => v.route
  }
}