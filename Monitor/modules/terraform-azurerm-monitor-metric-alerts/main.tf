resource "azurerm_monitor_metric_alert" "metric_alert" {
  for_each             = { for value in var.metric_alert : value.name => value }
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  scopes               = each.value.scopes
  description          = each.value.description
  target_resource_type = each.value.target_resource_type
  frequency            = each.value.frequency
  severity             = each.value.severity
  window_size          = each.value.window_size
  tags                 = each.value.tags

  dynamic "dynamic_criteria" {
    for_each = lookup(each.value, "dynamic_criteria", null) != null ? [each.value.dynamic_criteria] : []
    content {
      metric_namespace  = dynamic_criteria.value.metric_namespace
      metric_name       = dynamic_criteria.value.metric_name
      aggregation       = dynamic_criteria.value.aggregation
      operator          = dynamic_criteria.value.operator
      alert_sensitivity = dynamic_criteria.value.alert_sensitivity
    }
  }

  dynamic "criteria" {
    for_each = lookup(each.value, "criteria", null) != null ? [each.value.criteria] : []
    content {
      metric_namespace = criteria.value.metric_namespace
      metric_name      = criteria.value.metric_name
      aggregation      = criteria.value.aggregation
      operator         = criteria.value.operator
      threshold        = criteria.value.threshold
    }
  }
}
