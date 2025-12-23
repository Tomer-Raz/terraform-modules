# Azure Log Analytics Workspace Module

This module creates Azure Log Analytics Workspaces with customizable configurations and naming conventions.

## How to use this module

### 1. Prepare your JSON configuration file

Create a JSON file that contains the details of the Log Analytics Workspaces you want to create. Here's an example:

```json
{
  "name_convention": {
    "region": "eastus",
    "name": "a",
    "env": "prod",
    "cmdb_infra": "infra",
    "cmdb_project": "project1"
  },
  "workspaces": {
    "workspace1": {
      "rg_location": "East US",
      "rg_name": "my-resource-group",
      "sku": "PerGB2018",
      "retention_in_days": 30,
      "internet_ingestion_enabled": true,
      "internet_query_enabled": true,
      "tags": {
        "environment": "production",
        "project": "project1"
      }
    },
    "workspace2": {
      "rg_location": "West US",
      "rg_name": "another-resource-group",
      "sku": "PerGB2018",
      "retention_in_days": 60,
      "internet_ingestion_enabled": false,
      "internet_query_enabled": true,
      "tags": {
        "environment": "staging",
        "project": "project2"
      }
    }
  }
}
2. Call the module in your Terraform configuration
module "log_analytics_workspaces" {
  source = "path-to-module"

  name_convention = jsondecode(file("./path/to/log-analytics-config.json")).name_convention
  workspaces      = jsondecode(file("./path/to/log-analytics-config.json")).workspaces
}

# Accessing outputs
output "workspace_ids" {
  value = module.log_analytics_workspaces.workspace_ids
}

output "workspace_primary_shared_keys" {
  value     = module.log_analytics_workspaces.workspace_primary_shared_keys
  sensitive = true
}
Ensure that the Azure provider is properly configured with the necessary permissions to manage Log Analytics Workspaces.
