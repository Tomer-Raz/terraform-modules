locals {
  private_dns_zone_links = flatten([
    for dns_zone, links in var.private_dns_zones_links.links : [
      for link in links : {
        dns_zone = dns_zone,
        link = link
      }
    ]
  ])
}


resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_network_link" {
  for_each = { for link in local.private_dns_zone_links : "${link.dns_zone}-${basename(link.link)}" => link }

  name                  = "${each.key}-link"
  private_dns_zone_name = each.value.dns_zone
  resource_group_name   = var.private_dns_zones_links.common.resource_group_name
  virtual_network_id    = each.value.link

}