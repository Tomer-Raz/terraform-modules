output "alert_rule_ids" {
  description = "Map of Alert Rule names to their resource IDs"
  value = {
    for name, rule in azurerm_sentinel_alert_rule_ms_security_incident.security_incident :
    name => rule.id
  }
}

output "alert_rule_names" {
  description = "List of created Alert Rule names"
  value = keys(azurerm_sentinel_alert_rule_ms_security_incident.security_incident)
}