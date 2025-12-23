## Usage - Example KeyVault private endpoint

```terraform

locals {
  resource_groups = jsondecode(file("./json/rg.json"))
  kv              = jsondecode(file("./json/kv.json"))
  pe_details_with_outputs = merge(jsondecode(templatefile("./json/pe.json", {
    external = module.subnets.subnet_ids["synapse_blob"]
  })))
}

data "terraform_remote_state" "mgmt" {
  backend = "remote"
  config = {
    organization = "tomer__dev" # the organization in tfe
    workspaces = {
      name = "azure_azus_azus_mgmt_isource"
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
  kv_global_admins = var.kv_global_admins
  depends_on = [module.resource_group]
}

module "pes" {
  source                  = "./terraform-azurerm-private-endpoint"
  resource_group_name     = module.resource_group.resource_groups["synapse"].name
  location                = module.resource_group.resource_groups["synapse"].location
  name_convention         = local.pe.name_convention
  pe_details              = local.pe.pe_details_with_outputs
  private_dns_zones =  data.terraform_remote_state.mgmt.outputs.private_dns_zones
  destination_resource_id = module.kv.kv_id["cmk"]

  depends_on = [module.resource_group]
}


Input JSON Structure :

{
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "dev",
    "cmdb_infra": "azus",
    "cmdb_project": "spsh"
  },
  "pe_details": {
    "kvspsh": {
      "ip_configuration": {
        "name": "ipconfig5",
        "private_ip_address": "10.62.20.134",
        "subresource_name": "vault",
        "member_name":  "default"
      },
      "subnet_id":${kv_external}
      "private_service_connection": {
        "name": "kv-spsh",
        "is_manual_connection": "false",
        "subresource_names": ["vault"]
      },
      "private_dns_zone_names": ["privatelink.vaultcore.azure.net", "privatelink.blob.core.windows.net"]
    }
  }
}

```

## Requirements

No requirements.

## Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                   | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [azurerm_role_assignment.assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)                  | resource |
| [azurerm_user_assigned_identity.user_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name                                                                                          | Description                                         | Type                | Default | Required |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------- | ------------------- | ------- | :------: |
| <a name="input_location"></a> [location](#input_location)                                     | Azure location                                      | `string`            | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)    | Name of the resource group                          | `string`            | n/a     |   yes    |
| <a name="input_role_definition_name"></a> [role_definition_name](#input_role_definition_name) | Map of role definition names for each user identity | `map(string)`       | n/a     |   yes    |
| <a name="input_scopes"></a> [scopes](#input_scopes)                                           | Map of scopes for each user identity                | `map(list(string))` | n/a     |   yes    |
| <a name="input_user_identities"></a> [user_identities](#input_user_identities)                | Map of user identities to create                    | `map(string)`       | n/a     |   yes    |

## Outputs

| Name                                                                                | Description                            |
| ----------------------------------------------------------------------------------- | -------------------------------------- |
| <a name="output_role_assignments"></a> [role_assignments](#output_role_assignments) | All attributes of the role assignments |
| <a name="output_user_identities"></a> [user_identities](#output_user_identities)    | All attributes of the user identities  |
