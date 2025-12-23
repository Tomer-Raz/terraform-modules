resource "azurerm_monitor_private_link_scope" "main" {
  name                = "${local.name_prefix}-${var.ampls.name}-ampls"
  resource_group_name = var.ampls.resource_group_name
}

resource "azurerm_monitor_private_link_scoped_service" "main" {
  for_each            = { for value in var.ampls.scoped_resources : value.name => value }
  name                = "${each.value.name}-ampls-scope"
  linked_resource_id  = each.value.resource_id
  scope_name          = azurerm_monitor_private_link_scope.main.name
  resource_group_name = var.ampls.resource_group_name
}


module "ampls_private_endpoint" {
  source              = "source/modules/azurerm//modules/Network/modules/terraform-azurerm-private-endpoint"
  version             = "1.0.149"
  resource_group_name = var.ampls.resource_group_name
  location            = var.location
  pe_details          = { "ampls" : merge(var.ampls_pe.pe_details, { destination_resource_id = azurerm_monitor_private_link_scope.main.id }) }
  name_convention     = var.ampls_pe.name_convention
  private_dns_zones   = var.private_dns_zones
}
