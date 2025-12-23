## Usage

```terraform

locals {
  eventhub = jsondecode(file("./ccoe/eventhub.json"))
}

module "eventhub" {
  source = "./module/eventhub" # Update this with the path to your module

  resource_group_name = module.resource_group.resource_groups["we-ydev-azus-opdx-marketing-rg"].name
  namespaces = local.eventhub.namespaces
  eventhubs = local.eventhub.eventhubs

  providers = {
    azurerm = azurerm.subscription
  }
  depends_on = [module.resource_group]
}
```

JSON Example 

```json
{
    "namespaces": {
      "namespace1": {
        "name": "example-namespace1",
        "location": "westeurope",
        "sku": "Standard",
        "capacity": 1,
        "auto_inflate_enabled": false,
        "maximum_throughput_units": 0,
        "public_network_access_enabled": false
      }
    },
    "eventhubs": {
      "eventhub1": {
        "name": "example-eventhub1",
        "namespace_name": "namespace1",
        "partitions": 1,
        "message_retention": 1,
        "capture_enabled": false,
        "capture_encoding": "Avro",
        "blob_container_name": "example-container",
        "storage_account_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Storage/storageAccounts/exampleaccount"
      }
    },
    "consumer_groups": {
      "consumer_group1": {
        "name": "example-consumer-group1",
        "eventhub_name": "eventhub1",
        "namespace_name": "namespace1"
      }
    }
  }
```

Output Example

```terraform

output "eventhub_ids" {
  description = "The IDs of the Event Hubs"
  value       = { for eh in module.eventhub.eventhubs : eh.name => eh.id }
}

output "eventhub_namespace_ids" {
  description = "The IDs of the Event Hub Namespaces"
  value       = { for ns in module.eventhub.eventhub_namespaces : ns.name => ns.id }
}

output "namespace_name" {
  value = module.eventhub.eventhub_namespaces["namespace1"].name
}

output "eventhub_name" {
  value = module.eventhub.eventhubs["eventhub1"].name
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.11, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.11, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | A map of event hub names and their properties | <pre>map(object({<br>    name                = string<br>    namespace_name      = string<br>    partitions          = number<br>    message_retention   = number<br>    capture_enabled     = optional(bool)<br>    capture_encoding    = optional(string)<br>    blob_container_name = optional(string)<br>    storage_account_id  = optional(string)<br>    destination_name    = optional(string)<br>    archive_name_format = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | A map of namespace names and their properties | <pre>map(object({<br>    name                     = string<br>    location                 = string<br>    sku                      = string<br>    capacity                 = optional(number)<br>    auto_inflate_enabled     = optional(bool)<br>    maximum_throughput_units = optional(number)<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventhub_namespaces"></a> [eventhub\_namespaces](#output\_eventhub\_namespaces) | All attributes of the Event Hub Namespaces |
| <a name="output_eventhubs"></a> [eventhubs](#output\_eventhubs) | All attributes of the Event Hubs |
