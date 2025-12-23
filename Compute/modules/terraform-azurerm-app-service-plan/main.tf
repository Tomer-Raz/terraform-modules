resource "azurerm_service_plan" "plan" {
  for_each            = var.service_plan_list
  name                = "${local.name_prefix}-${each.key}-asp"
  location            = var.location
  resource_group_name = each.value.resource_group_name
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name
  worker_count        = each.value.worker_count
  tags                = var.tags
}

module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.197"

  for_each = var.service_plan_list
  resource_type = "Microsoft.Web/serverfarms"
  target_id = azurerm_service_plan.plan[each.key].id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}