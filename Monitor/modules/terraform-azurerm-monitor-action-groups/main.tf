resource "azurerm_monitor_action_group" "main" {
  for_each            = { for ag in var.action_groups : ag.name => ag }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  short_name          = each.value.short_name

  email_receiver {
    name          = each.value.email_receiver.name
    email_address = each.value.email_receiver.email_address
  }
}

