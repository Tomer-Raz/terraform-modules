## Usage

```terraform

locals {
  resource_groups = jsondecode(file("./json/rg.json"))
  kv  = jsondecode(file("./config/key_vault.json"))
}

module "resource_group" {
  source          = "./terraform-azurerm-rg"
  resource_groups = local.resource_groups.resource_groups
  name_convention = local.resource_groups.name_convention
}

module "kv" {
  source                        = "./terraform-azurerm-keyvault"
  resource_group_name           = module.resource_group.resource_groups["synapse"].name
  location                      = module.resource_group.resource_groups["synapse"].location
  kv_details                    = local.kv.kv_details
  name_convention               = local.kv.name_convention
  service_principal_permissions = local.kv.service_principal_permissions

  depends_on = [module.resource_group]
}

Ensure that you configure local.key_vault with the actual path to your JSON configuration file.

## JSON Configuration Files
This file defines the configuration for the Key Vault.

Example:

key_vault.json

{ 
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "dev",
    "cmdb_infra": "azus",
    "cmdb_project": "spsh"
  }, 
  "kv_details": {
    "cmk": {
      "purge_protection_enabled": true, 
      "enabled_for_disk_encryption": false, 
      "soft_delete_retention_days": 7, 
      "sku_name": "standard", 
      "public_network_access_enabled": "false",
      "enable_rbac_authorization": "false",
      "bypass": "AzureServices",
      "tags": { 
        "environment": "dev", 
        "project": "spsh" 
      }
    }
  },
  "service_principal_ids": {
    "c75a1f29-fe04-4dac-b332-7f5c18ae2e29": {
      "target_kv": "cmk",
      "key_permissions": [
        "Backup",
        "Create",
        "Decrypt",
        "Delete",
        "Encrypt",
        "Get",
        "Import",
        "List",
        "Purge",
        "Release",
        "Recover",
        "Restore",
        "Sign",
        "UnwrapKey",
        "Update",
        "Verify",
        "WrapKey",
        "SetRotationPolicy",
        "Rotate",
        "GetRotationPolicy"], 
      "secret_permissions": [
        "Backup",
        "Delete",
        "Get",
        "List",
        "Purge",
        "Recover",
        "Restore",
        "Set"], 
      "storage_permissions": [
        "Backup",
        "Delete",
        "DeleteSAS",
        "Get",
        "GetSAS",
        "List",
        "ListSAS",
        "Purge",
        "Recover",
        "RegenerateKey",
        "Restore",
        "Set",
        "SetSAS",
        "Update"],
      "certificate_permissions":[
        "Backup",
        "Create",
        "Delete",
        "DeleteIssuers",
        "Get",
        "GetIssuers",
        "Import",
        "List",
        "ListIssuers",
        "ManageContacts",
        "ManageIssuers",
        "Purge",
        "Recover",
        "Restore",
        "SetIssuers",
        "Update"]
    }
  }
}

```


## Notes

Ensure that the Azure provider is properly configured with the necessary permissions to manage Key Vault resources.
Make sure to use the correct module source and version. The module source in this example is "app.terraform.io/Vegvizer/ydy/azurerm//modules/Compute/modules/terraform-azurerm-keyvault/terraform-azurerm-keyvault" with version "1.0.7".
Adjust the JSON configuration file as needed for your specific Key Vault settings.