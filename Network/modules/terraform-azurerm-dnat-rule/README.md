# Azure Firewall Policy dnat Rule Collection Group Module

This module creates a dnat Rule Collection Group and dnat Rule Collections for an Azure Firewall Policy.

## How to use this module

1. Prepare your JSON configuration files:

   Create a directory for your JSON files (e.g., `./network/firewall_policies/dnat_rules`).

   In this directory, create:
   - A `dnat_group_config.json` file for the group configuration
   - One or more JSON files in a `dnat_collections` subdirectory for individual collections

2. Call the module in your Spoke Terraform configuration:

   module "firewall_dnat_rule_collection" {
     source = "path-to-module"
     
     firewall_policy_id               = "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.dnat/firewallPolicies/your-firewall-policy"
     json_dnat_policy_config_path  = "./json_files/firewall_policies/dnat_rules"

  }


## JSON Configuration Files

dnat_group_config.json:

This file defines the overall configuration for the rule collection group.
Example:

{
  "name": "dnat_rule_collection_group_name",
  "priority": 100
}

dnat Collection JSON Files
Create one or more JSON files in the dnat_collections subdirectory. Each file represents a separate dnat rule collection.
Example (dnat-collection-1.json):

{
  "name": "dnat-collection-1",
  "priority": 100,
  "action": "Dnat",
  "dnat_rules": [
    {
      "name": "dnat_rule_example",
      "protocols": ["TCP"],
      "source_addresses": ["31.2.0/24"],
      "source_ip_groups": [],
      "destination_addresses": ["135.62.8.64/28"],
      "destination_ip_groups": [],
      "destination_fqdns": [],
      "destination_ports": ["443", "80"],
      "translated_address": "10.62.8.64/28",
      "translated_port": "443",
    },
    {
      "name": "dnat_rule_example_2",
      "protocols": ["TCP"],
      "source_addresses": ["31.2.0/24"],
      "source_ip_groups": [],
      "destination_addresses": ["135.62.8.64/28"],
      "destination_ip_groups": [],
      "destination_fqdns": [],
      "destination_ports": ["443", "80"],
      "translated_address": "10.62.8.64/28",
      "translated_port": "443",
    }

  ]
}

## Notes

Ensure that the Azure provider is properly configured with the necessary permissions to manage Firewall Policies.
The module uses the azurerm.spoke provider alias. Make sure this is properly configured in your root module.
You can add multiple JSON files in the dnat_collections directory to create multiple dnat rule collections within the same group.