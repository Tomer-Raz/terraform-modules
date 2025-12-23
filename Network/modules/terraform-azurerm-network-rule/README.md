# Azure Firewall Policy Network Rule Collection Group Module

This module creates a Network Rule Collection Group and Network Rule Collections for an Azure Firewall Policy.

## How to use this module

1. Prepare your JSON configuration files:

   Create a directory for your JSON files (e.g., `./network/firewall_policies/network_rules`).

   In this directory, create:
   - A `network_group_config.json` file for the group configuration
   - One or more JSON files in a `network_collections` subdirectory for individual collections

2. Call the module in your Spoke Terraform configuration:

   module "firewall_network_rule_collection" {
     source = "path-to-module"
     
     firewall_policy_id               = "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.Network/firewallPolicies/your-firewall-policy"
     json_network_policy_config_path  = "./json_files/firewall_policies/network_rules"

     providers = {
       azurerm.spoke = azurerm.spoke
     }
   }


## JSON Configuration Files

network_group_config.json:

This file defines the overall configuration for the rule collection group.
Example:

{
  "name": "network_rule_collection_group_name",
  "priority": 100
}

Network Collection JSON Files
Create one or more JSON files in the network_collections subdirectory. Each file represents a separate network rule collection.
Example (network-collection-1.json):

{
  "name": "network-collection-1",
  "priority": 100,
  "action": "Allow",
  "network_rules": [
    {
      "name": "ALLOW_TCP_TO_INTERNAL",
      "protocols": ["TCP"],
      "source_addresses": ["10.0.2.0/24"],
      "source_ip_groups": [],
      "destination_addresses": ["10.62.8.64/28"],
      "destination_ip_groups": [],
      "destination_fqdns": [],
      "destination_ports": ["443", "80"]
    }
  ]
}

## Notes

Ensure that the Azure provider is properly configured with the necessary permissions to manage Firewall Policies.
The module uses the azurerm.spoke provider alias. Make sure this is properly configured in your root module.
You can add multiple JSON files in the network_collections directory to create multiple network rule collections within the same group.