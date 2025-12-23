output "log_analytics_workspaces" {
  description = "The Log Analytics Workspace IDs"
  value       = { for k, v in azurerm_log_analytics_workspace.law : k => v }
}