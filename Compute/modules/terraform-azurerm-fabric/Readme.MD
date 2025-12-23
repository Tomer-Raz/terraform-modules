
# Azure Fabric Module

This module provisions Fabric Capacity resources in Azure using the `azapi` provider. It supports customization through input variables for tags, naming conventions, and other configurations.

## Features

- Provisions `Microsoft.Fabric/capacities` resources.
- Supports dynamic configuration using `for_each` to create multiple resources.
- Flexible naming conventions.
- Tagging support.

---

## Requirements

### Providers

- **Terraform:** >= 1.0.0
- **azapi Provider:** Azure/azapi

### Azure Requirements

- Resource Group must exist before using this module.
- Appropriate Azure permissions to create Fabric resources.

---

## Usage

```hcl

locals {
  fabric_config   = jsondecode(file("./path/fabric-config.json"))
}

module "fabric_capacity" {
  source            = "./path/to/module"
  config            = local.fabric_config.fabric
  name_convention   = local.fabric_config.name_convention
  resource_group_id = module.resource_group.resource_groups["fabric-capacity"].id
  location          = module.resource_group.resource_groups["fabric-capacity"].location
}

```

---

## Inputs

| Name                 | Type     | Description                                     | Required |
|----------------------|----------|-------------------------------------------------|----------|
| `config`             | `map(object)` | Configuration for the fabric module. Each entry defines the settings for a Fabric resource. | Yes |
| `resource_group_id`  | `string` | Resource group ID.                              | Yes      |
| `location`           | `string` | Location of the resource group.                 | Yes      |
| `name_convention`    | `object` | Naming convention details: region, environment, infra, project. | Yes |

### Configuration Object Schema (`config`):

| Field          | Type          | Description                     | Required |
|----------------|---------------|---------------------------------|----------|
| `tags`         | `map(string)` | Key-value pairs for tagging.    | Yes      |
| `module_enabled` | `bool`       | Whether the module is enabled. | Yes      |
| `sku`          | `string`      | SKU for the capacity resource.  | Yes      |
| `admin_emails` | `list(string)` | List of admin email addresses.  | Yes      |

---

## Outputs

| Name  | Description                                      |
|-------|--------------------------------------------------|
| `id`  | Resource identifier of the first Fabric Capacity. |

---

## Naming Convention

The `name_convention` variable constructs resource names using the following schema:

```
region                    = string
name = string
env                       = string
cmdb_infra                = string
cmdb_project              = string
```

Example: `eastDPINFRAX`

---

## Example Configuration

```hcl
{
  "fabric": {
    "fabric-crm": {
      "tags": {
        "Environment": "iglb"
      },
      "module_enabled": true,
      "sku": "F2",
      "admin_emails": [
        "mail1@mail.com",
        "mail2@mail.com"
      ]
    }
  },
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "glb",
    "cmdb_infra": "azfb",
    "cmdb_project": "spsh"
  }
}
```

---

## Tags

Utilize the `tags` field in the `config` object to assign metadata to resources, which is useful for cost management and organization.

---

## Notes

- Ensure all required Azure permissions are in place before running the module.
- Verify the `azapi` provider is properly configured.

---

## License

This module is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## Authors

This module is maintained by the [Your Company/Team Name].
