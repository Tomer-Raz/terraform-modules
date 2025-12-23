resource "azurerm_monitor_activity_log_alert" "main" {
  for_each            = { for value in var.activity_log_alert : value.name => value }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  scopes              = each.value.scopes
  description         = each.value.description

  criteria {
    resource_id    = each.value.resource_id
    operation_name = each.value.operation_name
    category       = each.value.category
  }

  action {
    action_group_id = each.value.action_group_id
  }
}
