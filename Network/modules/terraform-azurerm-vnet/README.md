######################################################################
How to use this module in spoke:

locals {
  vnet_config            = jsondecode(file("path-to-json.json"))
}

module "vnets" {
  source = "path-to-module"

  vnets = local.vnet_config.vnets
  resource_group_name = var.resource_group_name # can also be output from rg module
  name_convention     = local.vnet_config.name_convention  

  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub   = azurerm.hub
  }
}

######################################################################
Example json file:
{
  "load_balancers": [
    {
      "name": "bigip",
      "location": "westeurope",
      "sku": "Standard",
      "frontend_ip_configuration_name": "bigip",
      "private_ip_address": "",
      "private_ip_address_allocation": "Dynamic",
      "subnet_id": "${externalSubnet}"
    }
  ],
  "lb_backend_address_pool": [
    {
      "load_balancer_key_name": "bigip"
    }
  ],
  "lb_backend_address_pool_address": [
    {
      "ip_address": "10.0.0.4",
      "load_balancer_key_name": "bigip",
      "virtual_network_id": "${f5Vnet}"
    }
  ],
  "lb_probe": [
    {
      "load_balancer_key_name": "bigip",
      "protocol": "Http",
      "port": 8888,
      "interval_in_seconds": 5,
      "number_of_probes": 1,
      "probe_threshold": 1,
      "request_path": "/"
    }
  ]
}