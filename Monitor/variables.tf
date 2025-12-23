# ./modules/monitor/variables.tf

variable "action_groups" {
  description = "Configuration for action groups"
  type        = any  # Define a more specific type based on your needs
}

variable "activity_log_alert" {
  description = "Configuration for activity log alerts"
  type        = any
}

variable "ampls" {
  description = "Configuration for Azure Monitor Private Link Scope"
  type        = any
}

variable "dashboard_files_folder_path" {
  description = "Path to the folder containing dashboard JSON files"
  type        = string
}

variable "dashboards" {
  description = "Configuration for dashboards"
  type        = any
}

variable "scheduled_query_rules_alert" {
  description = "Configuration for scheduled query rules alerts"
  type        = any
}

variable "metric_alert" {
  description = "Configuration for metric alerts"
  type        = any
}

variable "workspace_onboarding" {
  description = "Configuration for Sentinel workspace onboarding"
  type        = any
}

variable "security_incident" {
  description = "Configuration for Sentinel security incident alerts"
  type        = any
}

variable "wiz" {
  description = "Wiz app"
  type        = any
}

variable "table_retention" {
  description = "Table retention"
  type        = any
}