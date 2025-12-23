output "sentinel_workspace_onboarding" {
  description = "Map of onboarded workspaces with their IDs"
  value = {
    for workspace in azurerm_sentinel_log_analytics_workspace_onboarding.workspace_onboarding :
    workspace.workspace_id => workspace.id
  }
}