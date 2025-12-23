
resource "azurerm_eventgrid_namespace" "event_grid" {
  for_each = var.event_grid_namespace_setting
  name                  = "${local.name_prefix}-${each.value.name}-evgns"
  location              = each.value.location
  resource_group_name   = var.resource_group
  capacity              = each.value.capacity != null ? each.value.capacity :4
  public_network_access = each.value.public_network_access != null ? each.value.public_network_access : "disable"
  identity {
    type = each.value.identity_type

  }
    sku =each.value.sku != null ? each.value.sku : "Standard"

  topic_spaces_configuration {
    maximum_session_expiry_in_hours = each.value.topic_spaces_configurati_maximum_session_expiry_in_hours != null ? each.value.topic_spaces_configurati_maximum_session_expiry_in_hours :8
  }
}

module "diagnostic_management_clu" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.285"
  for_each =  azurerm_eventgrid_namespace.event_grid
  resource_type = "Microsoft.EventGrid/namespaces"
  target_id     = each.value.id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id
  name_convention = var.name_convention
}