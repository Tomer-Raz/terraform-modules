resource "azurerm_log_analytics_workspace" "law" {
  for_each = var.workspaces

  name                       = "${local.name_prefix}-${each.key}-law"
  location                   = each.value.rg_location
  resource_group_name        = each.value.rg_name
  sku                        = each.value.sku
  retention_in_days          = each.value.retention_in_days
  internet_ingestion_enabled = each.value.internet_ingestion_enabled
  internet_query_enabled     = each.value.internet_query_enabled

  tags = each.value.tags
}

module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"

  for_each = var.workspaces
  resource_type = "Microsoft.OperationalInsights/workspaces"
  target_id = azurerm_log_analytics_workspace.law[each.key].id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}