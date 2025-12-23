module "action_groups" {
  source        = "./modules/terraform-azurerm-monitor-action-groups"
  action_groups = var.action_groups
}

module "activity_log_alerts" {
  source             = "./modules/terraform-azurerm-monitor-activity-log-alerts"
  activity_log_alert = var.activity_log_alert
}

module "ampls" {
  source = "./modules/terraform-azurerm-monitor-ampls"
  ampls  = var.ampls
}

module "dashboards" {
  source                      = "./modules/terraform-azurerm-monitor-dashboards"
  dashboard_files_folder_path = var.dashboard_files_folder_path
  dashboards                  = var.dashboards
}

module "log_alerts" {
  source                      = "./modules/terraform-azurerm-monitor-log-alerts"
  scheduled_query_rules_alert = var.scheduled_query_rules_alert
}

module "metric_alerts" {
  source       = "./modules/terraform-azurerm-monitor-metric-alerts"
  metric_alert = var.metric_alert
}

module "sentinel_workspace_onboarding" {
  source               = "./modules/terraform-azurerm-log-analytics-workspace-onboarding"
  workspace_onboarding = var.workspace_onboarding
}

module "sentinel_security_incident" {
  source            = "./modules/terraform-azurerm-ms-security-incident"
  security_incident = var.security_incident
}

module "wiz" {
  source = "./modules/terraform-azurerm-wiz"
  wiz    = var.wiz
}

module "table_retention" {
  source          = "./modules/terraform-azurerm-log-analytics-workspace-table"
  table_retention = var.table_retention
}
