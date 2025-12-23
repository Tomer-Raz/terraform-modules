# Terraform Module: Azure Event Grid Namespace with Diagnostics

This module creates and configures an Azure Event Grid Namespace resource along with diagnostic settings.

## Features

- Creates Azure Event Grid Namespace resources based on input settings.
- Configures identity, SKU, public network access, and topic spaces.
- Integrates with a diagnostics management module to enable monitoring and logging.

## Usage

```hcl
module "event_grid" {
  source = "./path/to/your/module"

  event_grid_namesoace_setting = {
    example1 = {
      name                          = "example"
      location                      = "East US"
      resource_group_name           = "example-rg"
      capacity                      = 4
      public_network_access         = "disable"
      identity_type                 = "SystemAssigned"
      sku                           = "Standard"
      topic_spaces_configurati_maximum_session_expiry_in_hours = 8
    }
  }

  secmon_law_id  = "<your-secmon-law-id>"
  opsmon_law_id  = "<your-opsmon-law-id>"
  name_convention = "<your-name-convention>"
}
```

## Resources Created

This module creates:

- `azurerm_eventgrid_namespace`
  - Configures Event Grid Namespace with the specified settings.
- Diagnostic settings via the `diagnostic_management_event_grid` module.

## Inputs

| Name                                          | Description                                                   | Type   | Default | Required |
|-----------------------------------------------|---------------------------------------------------------------|--------|---------|----------|
| `event_grid_namesoace_setting`                | Map of settings for Event Grid Namespace resources.           | `map`  | n/a     | yes      |
| `secmon_law_id`                               | Security monitoring Log Analytics Workspace ID.               | `string` | n/a     | yes      |
| `opsmon_law_id`                               | Operations monitoring Log Analytics Workspace ID.             | `string` | n/a     | yes      |
| `name_convention`                             | Naming convention for diagnostic settings.                    | `string` | n/a     | yes      |

### Event Grid Namespace Settings (Map)
Each key in the `event_grid_namesoace_setting` map corresponds to an Event Grid Namespace and includes:

| Key                                  | Description                                                   | Type   | Default | Required |
|--------------------------------------|---------------------------------------------------------------|--------|---------|----------|
| `name`                               | Name of the Event Grid Namespace.                             | `string` | n/a     | yes      |
| `location`                           | Azure region for the namespace.                               | `string` | n/a     | yes      |
| `resource_group_name`                | Resource group for the namespace.                             | `string` | n/a     | yes      |
| `capacity`                           | Capacity of the namespace. Default is `4`.                    | `number` | 4       | no       |
| `public_network_access`              | Public network access setting. Default is `disable`.          | `string` | "disable" | no       |
| `identity_type`                      | Type of managed identity.                                     | `string` | n/a     | yes      |
| `sku`                                | SKU for the namespace. Default is `Standard`.                 | `string` | "Standard" | no       |
| `topic_spaces_configurati_maximum_session_expiry_in_hours` | Max session expiry in hours. Default is `8`. | `number` | 8       | no       |

## Outputs

| Name                  | Description                                   |
|-----------------------|-----------------------------------------------|
| `event_grid_namespace`| Map of created Event Grid Namespace resources.|

## Requirements

- Terraform version >= 1.3
- AzureRM Provider >= 3.0

## Notes

- Ensure that the `diagnostic_management_event_grid` module path is correctly set in the `source` parameter.
- Provide valid `secmon_law_id` and `opsmon_law_id` for diagnostic settings.

## Example json

{
    "name_convention": {
        "region": "we",
        "name": "d",
        "env": "prd",
        "cmdb_infra": "lang",
        "cmdb_project": "opxa"
      },
      "resorce" :{
        "object1" : { 
                    "name"  :"re",
                    "location" :"West Europe",
                    "resource_group_name" :"event-grid-rg",
                    "capacity" :1,
                    "public_network_access" :"Enabled",
                    "identity_type" :"SystemAssigned",
                    "topic_spaces_configurati_maximum_session_expiry_in_hours" :1
           
                    

    }
}
}












Refer to the `Usage` section for a complete example of how to use this module.

## Authors

This module is maintained by [Your Team/Organization Name].

## License

This project is licensed under the [MIT License](LICENSE).
