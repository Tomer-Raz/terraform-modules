Terraform Module: Storage Account Configuration
This Terraform module provides a way to configure and manage Azure Storage Accounts with customizable options and features.
Features
•	Define storage accounts with multiple configurations.
•	Enable secure settings using customer-managed keys (CMK).
•	Control access to resources with network rules.
•	Automate resource provisioning in Azure.
Usage
module "storage_account" {
  source = "./path/to/module"

  # Pass the required variables here
  resource_group_name = "realtrm-rg"
  location            = "westus"
  storage_accounts = {
    account1 = {
      name                        = "st"
      account_tier                = "Standard"
      account_replication_type    = "LRS"
      account_kind                = "StorageV2"
      network_action              = "Deny"
      public_network_access_enabled = false
      allow_nested_items_to_be_public = false
      bypass                      = ["Logging", "Metrics"]
      cmk = {
        key_vault_id = "/subscriptions/7889b521-02b2-43e1-84bf-39a040cedf8e/resourceGroups/we-ydy-sendbox-2-2-hub-rg/providers/Microsoft.KeyVault/vaults/key-vault-crm-ydy"
        key_name     = "P2SRootCert"
        key_version  = "8f1fabf66daf4e938702a4056a363a56"
        tenant_id    = "ac32ce31-21bc-40f0-81ca-71c54057fde4"
      }
    }
  }
}
Inputs
Name	Description	Type	Default	Required
resource_group_name	Name of the resource group to use.	string	n/a	yes
location	Azure region for the resources.	string	n/a	yes
storage_accounts	Map of storage account configurations.	map	n/a	yes
Outputs
Name	Description
storage_account_names	Names of the created storage accounts
Example Configuration
The following is an example JSON configuration that can be used with this module:
{
  "name_convention": {
    "region": "we",
    "name": "d",
    "env": "prd",
    "cmdb_infra": "lang",
    "cmdb_project": "opxa"
  },
  "resource_group_name": "realtrm-rg",
  "location": "westus",
  "storage_accounts": {
    "account1": {
      "name": "st",
      "account_tier": "Standard",
      "account_replication_type": "LRS",
      "account_kind": "StorageV2",
      "network_action": "Deny",
      "public_network_access_enabled": false,
      "allow_nested_items_to_be_public": false,
      "bypass": ["Logging", "Metrics"],
      "cmk": {
        "key_vault_id": "/subscriptions/7889b521-02b2-43e1-84bf-39a040cedf8e/resourceGroups/we-ydy-sendbox-2-2-hub-rg/providers/Microsoft.KeyVault/vaults/key-vault-crm-ydy",
        "key_name": "P2SRootCert",
        "key_version": "8f1fabf66daf4e938702a4056a363a56",
        "tenant_id": "ac32ce31-21bc-40f0-81ca-71c54057fde4"
      }
    }
  }
}
Requirements
•	Terraform >= 1.0.0
•	Azure provider >= 3.0

run moule command 
module "storeg_account" {
  source = "./moudle/terraform-azurerm-storage-account"
  resource_group_name = "realtrm-rg2"
  location            = local.storage-account-config.location
  storage_accounts    = local.storage-account-config.storage_accounts
  
  name_convention     = local.storage-account-config.name_convention
  opsmon_law_id ="/subscriptions/097f24e6-7d2c-439a-b79e-1029c5ed0fa0/resourceGroups/tomer-example-rg-1/providers/Microsoft.OperationalInsights/workspaces/we-ydy-opsmon-example"
  secmon_law_id ="/subscriptions/014a3d4b-7ecb-4f5d-b83b-37fee56640f2/resourceGroups/we-ydev-msft-secmon-rg/providers/Microsoft.OperationalInsights/workspaces/we-ydev-msft-secmon-law"

  depends_on = [ azurerm_resource_group.real_time ]

  
}