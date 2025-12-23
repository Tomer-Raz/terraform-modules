resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  for_each = { 
    for setting in var.diagnostic_setting : local.sanitized_name => setting
    if length(setting.enabled_logs) > 0 || length(setting.metrics) > 0
  }

  name                       = local.sanitized_name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = each.value.law_id

  dynamic "enabled_log" {
    for_each = each.value.enabled_logs
    content {
      category = enabled_log.value.category
    }
  }

  dynamic "metric" {
    for_each = each.value.metrics
    content {
      category = metric.value.category
      enabled  = each.value.type == "ops" ? true : false
    }
  }
}