######################################################################

How to use this module:

locals {
load_balancer_config = jsondecode(file("./tf_code/json_files load_balancer_config.json"))
}

module "load_balancer" {
source = "./tf_code/modules/load_balancer"
load_balancers = local.load_balancer_config.load_balancers
resource_group_name = local.load_balancer_config.resource_group_name
name_convention = local.load_balancer_config.name_convention
lb_backend_address_pool = local.load_balancer_config.lb_backend_address_pool
lb_backend_address_pool_address = local.load_balancer_config.lb_backend_address_pool_address
lb_probe = local.load_balancer_config.lb_probe
}

######################################################################

the following needs to be provided as a secret:

variable "subscription_id" {
type = string
description = "description"
}

variable "tenant_id" {
type = string
description = "description"
}

######################################################################

Example hub json file:
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
"lb_backend_address_pool": {
"pool1": {
"load_balancer_key_name": "bigip"
}
},
"lb_backend_address_pool_address": {
"pool_address1": {
"ip_address": "10.0.0.4",
"load_balancer_key_name": "bigip",
"virtual_network_id": "${f5Vnet}"
}
},
"lb_probe": {
"prob1": {
"load_balancer_key_name": "bigip",
"protocol": "Http",
"port": 8888,
"interval_in_seconds": 5,
"number_of_probes": 1,
"probe_threshold": 1,
"request_path": "/"
}
}
}
