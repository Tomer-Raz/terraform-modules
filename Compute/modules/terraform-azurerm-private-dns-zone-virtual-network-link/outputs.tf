output "private_dns_zone_network_link" {
  value = {for k, v in azurerm_private_dns_zone_virtual_network_link.private_dns_zone_network_link : k => v}
}