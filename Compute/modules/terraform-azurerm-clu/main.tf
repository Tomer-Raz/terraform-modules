
resource "azurerm_cognitive_account" "cognitive_account" {
  for_each                      = var.cognitive_services_settings
  name                          = "${local.name_prefix}-${each.value.name}-lang"
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  kind                          = each.value.kind
  sku_name                      = each.value.sku_name
  public_network_access_enabled = each.value.public_network_access_enabled
  custom_subdomain_name         = each.value.custom_subdomain_name
  local_auth_enabled            = each.value.local_auth_enabled
}

module "diagnostic_management_clu" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"
  for_each = azurerm_cognitive_account.cognitive_account

  resource_type = "Microsoft.CognitiveServices/accounts"
  target_id     = each.value.id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}
