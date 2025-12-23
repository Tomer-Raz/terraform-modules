## Usage

```terraform

locals {
  resource_groups = jsondecode(file("./json/rg.json"))
  kv  = jsondecode(file("./config/key_vault.json"))
  kv_data         = jsondecode(file("./json/kv_inputs.json"))
  external_secret = {
    "ext-secret" = {
      value  = "test"
      expiration_date = "2026-03-04T00:00:00Z"
    }
  }
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

module "kv_mngmt" {
  source       = "./terraform-azurerm-keyvault_mngmt"
  key_vault_id = module.kv.kv_id["cmk"]
  secrets      = local.kv_data["secrets"]
  certificates = local.kv_data["certificates"]
  keys         = local.kv_data["keys"]
}

module "kv_mngmt_json_and_external" {
  source       = "./terraform-azurerm-keyvault_mngmt"
  key_vault_id = module.kv.kv_id["cmk"]
  secrets      = merge(local.kv_data["secrets"], local.external_secret)
  certificates = local.kv_data["certificates"]
  keys         = local.kv_data["keys"]
}

Ensure that you configure local.key_vault with the actual path to your JSON configuration file.

## JSON Configuration Files
This file defines the configuration for the Key Vault.

Example:

kv_inputs.json

{
  "secrets": {
    "mySecret1": {
      "value": "supersecretvalue1",
      "expiration_date": "2026-03-04T00:00:00Z"
    },
    "mySecret2": {
      "value": "supersecretvalue2",
      "expiration_date": "2026-03-04T00:00:00Z"
    }
  },
  "certificates": {
    "jwt-dev-cert": {
      "certificate": {
        "contents": "./Files/jwt_cmk_18032025.pfx",
        "password": "tomer160"
      } 
    }
  },
  "keys": {
    "enckey": {
      "key_size": "2048",
      "key_type": "RSA",
      "key_opts": [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
    }
  }
}


```


## Notes

Ensure that the Azure provider is properly configured with the necessary permissions to manage Key Vault resources.
Make sure to use the correct module source and version. The module source in this example is "app.terraform.io/Vegvizer/ydy/azurerm//modules/Compute/modules/terraform-azurerm-keyvault/terraform-azurerm-keyvault" with version "1.0.7".
Adjust the JSON configuration file as needed for your specific Key Vault settings.