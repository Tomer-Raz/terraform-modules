## Usage

```json
[
  {
    "key": "role-storage_account",
    "scope": "${scopeid}",
    "role": "Reader",
    "principal_id": "terraform_cloud_admin",
    "principal_type": "Group"
  },
  {
    "key": "blob-storage_account",
    "scope": "${scopeid2}",
    "role": "Reader",
    "principal_id": "terraform_cloud_admin",
    "principal_type": "Group"
  },
  {
    "key": "user-storage_account",
    "scope": "${scopeid2}",
    "role": "Reader",
    "principal_id": "hadark@giladkgmail.onmicrosoft.com",
    "principal_type": "User"
  },
  {
    "key": "spn-storage_account",
    "scope": "${scopeid2}",
    "role": "Reader",
    "principal_id": "Terraform Cloud",
    "principal_type": "ServicePrincipal"
  }
]
```

```terraform

locals {
  azure_rbac = jsondecode(templatefile("./ccoe/role-assignment.json", {
    scopeid  = module.static-website.storage_account_ids["static-web-1"]
    scopeid2 = module.static-website.storage_account_ids["blob"]
  }))
}


module "role-assignment" {
  source = "./module/role-assignment"
  azure_rbac = local.azure_rbac
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_group.name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_user.name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_rbac"></a> [azure\_rbac](#input\_azure\_rbac) | n/a | <pre>list(object({<br>    key          = string<br>    scope        = string<br>    role         = string<br>    principal_id = string<br>    principal_type = string # "Group", "User", or "ServicePrincipal"<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments) | All of the role assignments |
