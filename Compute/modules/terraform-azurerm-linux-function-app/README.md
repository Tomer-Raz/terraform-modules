Linux Function App Module
This module creates an Azure Linux Function App and associates it with a Service Plan, Storage Account, and optional Virtual Network integration.
How to use this module

Prepare your JSON configuration file:
Create a JSON file that contains the details of the Linux Function Apps you want to create. Here's an example:
{
  "location": "westus",
  "tags": {
    "environment": "production"
  },
  "linux_function_apps": {
    "app1": {
      "name": "my-linux-function-app-1",
      "resource_group_name": "my-resource-group",
      "service_plan_id": "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Web/serverfarms/my-service-plan",
      "storage_account_name": "mystorageaccount",
      "subnet_id": "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet",
      "site_config": {
        "always_on": true,
        "app_command_line": "",
        "application_stack": {
          "node_version": "16"
        }
      },
      "app_settings": {
        "MY_SETTING": "my-value"
      }
    },
    "app2": {
      "name": "my-linux-function-app-2",
      "resource_group_name": "my-resource-group",
      "service_plan_id": "/subscriptions/your-subscription-id/resourceGroups/my-resource-group/providers/Microsoft.Web/serverfarms/my-service-plan",
      "storage_account_name": "mystorageaccount",
      "site_config": {
        "always_on": true,
        "app_command_line": "",
        "application_stack": {
          "dotnet_version": "6"
        }
      },
      "app_settings": {
        "MY_SETTING": "my-value"
      }
    }
  }
}

Call the module in your Terraform configuration:
 module "linux_function_app" {
  source = "path-to-module"

  config = jsondecode(file("./path/to/linux-function-app-config.json"))
}

Ensure that the Azure provider is properly configured with the necessary permissions to manage Linux Function Apps, Service Plans, and Storage Accounts.