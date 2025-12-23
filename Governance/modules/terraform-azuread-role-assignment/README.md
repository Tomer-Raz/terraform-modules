## Usage

```terraform

locals {
    azuread_role_assignment = jsondecode(file("./ccoe/azuread-role-assignment.json"))
}

module "azuread-role-assignment" {
  source = "./module/azuread-role-assignment"

  roles_assignments = local.azuread_role_assignment  
}
```

JSON Example

```json
[
    {
        "role_template_id": "f2ef992c-3afb-46b9-b7cf-a126ee74c451",
        "principal_object_ids": [
            "7b033fe8-52db-43cf-987c-20abac52bf05",
            "524a5584-1475-449c-9813-d26d42903d19"
        ]
    },
    {
        "role_template_id": "69091246-20e8-4a56-aa4d-066075b2a7a8",
        "principal_object_ids": [
            "7b033fe8-52db-43cf-987c-20abac52bf05"
        ]
    }
]
```

Output Example

```terraform
output "azuread_role_assignments" {
  value = module.azuread-role-assignment.role_assignments
  description = "All role assignments created by the azuread_role_assignment module."
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_directory_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_roles_assignments"></a> [roles\_assignments](#input\_roles\_assignments) | A list of role assignments, where each item is an object containing a role\_template\_id and a list of principal\_object\_ids | <pre>list(object({<br>    role_template_id     = string<br>    principal_object_ids = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments) | All role assignments created. |
