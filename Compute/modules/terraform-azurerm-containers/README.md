# Azure Storage Container Terraform Module

This Terraform module creates multiple containers in an Azure Storage Account, allowing for individual configuration of each container's access type.

## Features

- Create multiple Azure Storage containers in a single module call
- Configure access type for each container individually
- Use JSON format for easy configuration management

## Usage

To use this module, include the following in your Terraform configuration:

locals {
  containers = jsondecode(file("path/to/containers.json"))
}

module "storage_containers" {

  source = "path/to/azure_storage_container_module"
  storage_account_name = azurerm_storage_account.example.name  
  containers           = local.containers
}

### Input Variables

- `storage_account_name` (string): The name of the Azure Storage Account where containers will be created.
- `containers` (map): A map of container configurations, typically loaded from a JSON file.

###  JSON file 

The JSON file should be structured as follows:

```json
{
  "container_name_1": {
    "access_type": "private"
  }
}
```

## Outputs

- `container_ids`: A map of container names to their respective resource IDs.
