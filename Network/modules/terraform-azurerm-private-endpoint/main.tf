resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.pe_details

  name                = "${local.name_prefix}-${each.key}-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = each.value.subnet_id

  dynamic "ip_configuration" {
    for_each = (lookup(each.value, "ip_configurations", null) != null ? each.value.ip_configurations :
    lookup(each.value, "ip_configuration", null) != null ? [each.value.ip_configuration] : [])

    content {
    name               = each.value.ip_configuration.name
    private_ip_address = each.value.ip_configuration.private_ip_address
    subresource_name   = each.value.ip_configuration.subresource_name
    member_name        = each.value.ip_configuration.member_name 
    }
  }

  private_service_connection {
    name                           = "${each.value.private_service_connection.name}-privateserviceconnection"
    private_connection_resource_id = each.value.destination_resource_id
    is_manual_connection           = each.value.private_service_connection.is_manual_connection
    subresource_names              = each.value.private_service_connection.subresource_names
  }

  private_dns_zone_group {
    name                 = "privatelink-dns-zone-group-${lookup(each.value, "ip_configuration", null) != null ? each.value.ip_configuration.subresource_name : "default"}"
    private_dns_zone_ids = [for dns_zone_name in each.value.private_dns_zone_names : var.private_dns_zones[dns_zone_name]]
  }

  lifecycle {
    ignore_changes = [tags, ]
  }
}
