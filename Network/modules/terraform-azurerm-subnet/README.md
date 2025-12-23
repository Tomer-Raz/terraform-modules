# Azure Subnet and Route Table Module

This module creates subnets, route tables, and their associations in Azure.

## Usage

locals {
  config = jsondecode(file("path-to-json-config-file"))
}

module "subnets_and_route_tables" {
  source = "path-to-module"

  resource_group_name = local.config.resource_group_name
  name_convention     = local.config.name_convention
  subnets             = local.config.subnets
  route_tables        = local.config.route_tables
  associations        = local.config.associations

  depends_on = [module.vnets]
}
Input JSON Structure
jsonCopy{
  "resource_group_name": "example-rg",
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "dev",
    "cmdb_infra": "2",
    "cmdb_project": "2"
  },
  "subnets": {
    "example-subnet": {
      "virtual_network_name": "example-vnet",
      "address_prefixes": ["10.20.0.0/26"]
    },
    "example-subnet-with-delegetion": {
      "virtual_network_name": "example-vnet",
      "address_prefixes": ["10.20.0.64/26"],
      "delegation_service": "Microsoft.Web/serverFarms",
      "delegation_actions": ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  },
  "route_tables": {
    "rt-example": {
      "location": "westeurope",
      "routes": {
        "route1": {
          "name": "route-hub",
          "address_prefix": "0.0.0.0/0",
          "next_hop_type": "VirtualAppliance",
          "next_hop_in_ip_address": ""
        }
      }
    }
  },
  "associations": {
    "assoc1": {
      "subnet_name": "example-subnet",
      "route_table_name": "rt-example"
    }
  }
}
