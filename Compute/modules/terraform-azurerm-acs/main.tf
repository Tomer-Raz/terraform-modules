resource "azurerm_communication_service" "acs" {
  for_each             = var.acs_resources
  name                 = "${local.name_prefix}-${each.key}-acs"
  resource_group_name  = var.resource_group
  data_location        = each.value.data_location
}

resource "azapi_update_resource" "acs_identity" {
  for_each    = var.acs_resources
  type        = "Microsoft.Communication/communicationServices@2023-04-01-preview"
  resource_id = azurerm_communication_service.acs[each.key].id

  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
  })

  depends_on = [azurerm_communication_service.acs]
}

module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.285"

  for_each        = var.acs_resources
  resource_type   = "microsoft.communication/communicationservices"
  target_id       = azurerm_communication_service.acs[each.key].id
  secmon_law_id   = var.secmon_law_id
  opsmon_law_id   = var.opsmon_law_id
  name_convention = var.name_convention
}