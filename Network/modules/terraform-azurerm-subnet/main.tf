resource "azurerm_route_table" "route_tables" {
  for_each = var.route_tables != null ? var.route_tables : {}

  name                          = "${local.name_prefix}-${each.key}-rt"
  location                      = each.value.location
  resource_group_name           = var.resource_group_name

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = "${local.name_prefix}-${each.key}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  private_endpoint_network_policies = "Enabled"

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  for_each = var.associations != null ? var.associations : {}

  subnet_id      = azurerm_subnet.subnet[each.value.subnet_name].id
  route_table_id = azurerm_route_table.route_tables[each.value.route_table_name].id

  depends_on = [
    azurerm_subnet.subnet,
    azurerm_route_table.route_tables
  ]
}
