resource "azurerm_sentinel_alert_rule_ms_security_incident" "security_incident" {
  for_each                   = { for value in var.security_incident : value.name => value }
  name                       = each.value.name
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  display_name               = each.value.name
  product_filter             = each.value.product_filter
  severity_filter            = each.value.severity_filter
  enabled                    = each.value.enabled
}
