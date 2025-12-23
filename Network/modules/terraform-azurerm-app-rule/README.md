# Azure Firewall Policy Application Rule Collection Group Module

This module creates an Application Rule Collection Group for an Azure Firewall Policy.

## How to use this module

1. Prepare your JSON configuration files:

   Create a directory for your JSON files (e.g., `./network/firewall_policies/application_rules`).

   In this directory, create:
   - An `app_group_config.json` file for the group configuration
   - One or more JSON files in an `app_collections` subdirectory for individual collections

2. Call the module in your Terraform configuration:

   module "firewall_application_rule_collection" {
     source = "path-to-module"
     
     firewall_policy_id              = "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.Network/firewallPolicies/your-firewall-policy"
     json_app_policy_config_path     = "./configurations/firewall_policies/application_rules"

     providers = {
       azurerm.spoke = azurerm.spoke
     }
   }

   markdownCopy# Azure Firewall Policy Application Rule Collection Group Module

This module creates an Application Rule Collection Group for an Azure Firewall Policy.

## How to use this module

1. Prepare your JSON configuration files:

   Create a directory for your JSON files (e.g., `./configurations/firewall_policies/application_rules`).

   In this directory, create:
   - An `app_group_config.json` file for the group configuration
   - One or more JSON files in an `app_collections` subdirectory for individual collections

2. Call the module in your Terraform configuration:

   ```hcl
   module "firewall_application_rule_collection" {
     source = "path-to-module"
     
     firewall_policy_id              = "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.Network/firewallPolicies/your-firewall-policy"
     json_app_policy_config_path     = "./configurations/firewall_policies/application_rules"

     providers = {
       azurerm.spoke = azurerm.spoke
     }
   }


JSON Configuration Files Examples:

app_group_config.json:
This file defines the overall configuration for the rule collection group.
Example:
jsonCopy{
  "name": "application_rule_collection_group_allow_hub_spoke",
  "priority": 200
}

Application Collection JSON Files:

Create one or more JSON files in the app_collections subdirectory. Each file represents a separate application rule collection.

Example (app-collection-1.json):
jsonCopy{
  "name": "app-collection-1",
  "priority": 100,
  "action": "Allow",
  "app_rules": [
    {
      "name": "ALLOW_HTTPS_TO_MICROSOFT",
      "source_addresses": ["10.0.1.0/24", "10.0.2.0/24"],
      "source_ip_groups": [],
      "destination_fqdns": ["*.microsoft.com"],
      "destination_fqdn_tags": [],
      "protocols": [
        {
          "type": "Https",
          "port": 443
        }
      ]
    }
  ]
}


Ensure that the Azure provider is properly configured with the necessary permissions to manage Firewall Policies.
The module uses the azurerm.spoke provider alias. Make sure this is properly configured in your root module.
You can add multiple JSON files in the app_collections directory to create multiple application rule collections within the same group.