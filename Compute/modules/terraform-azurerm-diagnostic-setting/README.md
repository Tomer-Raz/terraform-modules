# Azure Monitor Diagnostic Setting Terraform Module

This module creates Azure Monitor Diagnostic Settings for various Azure resources.

## Usage

```hcl
module "diagnostic_setting" {
  source = "path/to/this/module"

  diagnostic_setting = jsondecode(file("diagnostic_settings.json"))
}
Input
The module expects a JSON file (diagnostic_settings.json) with the following structure:
jsonCopy[
  {
    "name": "example-diag-setting",
    "target_resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorageaccount",
    "law_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law",
    "enabled_logs": [
      {
        "category": "StorageRead"
      },
      {
        "category": "StorageWrite"
      }
    ],
    "metrics": [
      {
        "category": "Transaction"
      }
    ]
  }
]


Important Note!!
To enable all available log categories for a resource, you can use an empty object {} in the enabled_logs list. Similarly, to enable all available metrics, use an empty object in the metrics list. Here's an example:
json[
  {
    "name": "all-categories-example",
    "target_resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorageaccount",
    "law_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law",
    "enabled_logs": [
      {}
    ],
    "metrics": [
      {}
    ]
  }
]