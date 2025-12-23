resource "azurerm_log_analytics_workspace_table" "table_retention" {
  for_each                = var.table_retention
  name                    = each.key
  workspace_id            = var.workspace_id
  retention_in_days       = each.value.retention_in_days
  total_retention_in_days = each.value.total_retention_in_days
  plan                    = each.value.plan
}

