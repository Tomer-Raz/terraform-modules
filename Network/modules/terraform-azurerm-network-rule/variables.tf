variable "firewall_policy_id" {
  type        = string
  description = "The ID of the Firewall Policy where the Network Rule Collection Group should be created."
}

variable "json_network_policy_config_path" {
  type        = string
  description = "Full path to the directory containing network policy JSON configuration files"
}