output "action_group_ids" {
  value = { for ag in azurerm_monitor_action_group.main : ag.name => ag.id }
}