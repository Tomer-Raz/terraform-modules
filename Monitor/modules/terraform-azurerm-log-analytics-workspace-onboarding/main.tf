resource "azurerm_sentinel_log_analytics_workspace_onboarding" "workspace_onboarding" {
  for_each                     = var.workspace_onboarding
  workspace_id                 = each.value.workspace_id
  customer_managed_key_enabled = each.value.customer_managed_key_enabled  
}