variable "firewall_policy_id" {
  type        = string
  description = "The ID of the Firewall Policy where the Application Rule Collection Group should be created."
}

variable "json_app_policy_config_path" {
  type        = string
  description = "Full path to the directory containing application policy JSON configuration files"
}