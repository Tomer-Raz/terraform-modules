variable "firewall_policy_id" {
  type        = string
  description = "The ID of the Firewall Policy where the DNAT Rule Collection Group should be created."
}

variable "json_dnat_policy_config_path" {
  type        = string
  description = "Full path to the directory containing DNAT policy JSON configuration files"
}