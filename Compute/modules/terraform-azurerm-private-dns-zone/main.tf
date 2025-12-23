resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = var.private_dns_zones.zones
  name                = each.value
  resource_group_name = var.private_dns_zones.common.resource_group_name
  lifecycle {
    ignore_changes = [ tags, ]
  }
}
