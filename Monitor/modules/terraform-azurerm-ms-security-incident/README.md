# Azure Sentinel Alert Rule (Microsoft Security Incident) Module

This module creates Azure Sentinel Alert Rules for Microsoft Security Incidents, allowing you to configure multiple alert rules with customizable settings.

## How to use this module

### 1. Prepare your JSON configuration file

Create a JSON file that contains the details of the Sentinel Alert Rules you want to create. Here's an example:

```json
{
  "security_incident": [
    {
      "name": "high-severity-azure-ad-incidents",
      "log_analytics_workspace_id": "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.OperationalInsights/workspaces/your-workspace",
      "product_filter": "Azure Active Directory Identity Protection",
      "severity_filter": ["High"],
      "enabled": true
    },
    {
      "name": "medium-severity-azure-security-center-incidents",
      "log_analytics_workspace_id": "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.OperationalInsights/workspaces/your-workspace",
      "product_filter": "Azure Security Center",
      "severity_filter": ["Medium"],
      "enabled": true
    }
  ]
}
2. Call the module in your Terraform configuration
module "sentinel_alert_rules" {
  source = "path-to-module"

  security_incident = jsondecode(file("./path/to/sentinel-alert-rules-config.json")).security_incident
}
Ensure that the Azure provider is properly configured with the necessary permissions to manage Azure Sentinel and Log Analytics Workspaces.