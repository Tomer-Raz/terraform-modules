resource "azurerm_synapse_workspace_security_alert_policy" "synapse_alert_policy" {
  synapse_workspace_id       = var.synapse_workspace_id
  policy_state               = "Enabled"
  #storage_endpoint           = var.primary_blob_endpoint
  disabled_alerts            = var.disabled_alerts 
  retention_days             = 90
}

resource "azurerm_synapse_workspace_vulnerability_assessment" "synapse_vuln_assessment" {
  workspace_security_alert_policy_id = azurerm_synapse_workspace_security_alert_policy.synapse_alert_policy.id
  storage_container_path             = "${var.primary_blob_endpoint}${var.container_name}/"
  recurring_scans {
    enabled = true
    emails  = var.emails
  }
}