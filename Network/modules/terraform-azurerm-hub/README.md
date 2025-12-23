######################################################################

How to use this module:

locals {
  hub_config         = jsondecode(file("./json_files/hub.json"))
  additional_fw_pips = jsondecode(file("./json_files/additional_fw_pips.json"))
}

module "hub" {
  source = "./module"

  hub                   = local.hub_config
  additional_fw_pips    = local.additional_fw_pips.additional_fw_pips   # optional - defaults to null
  shared_key            = var.shared_key
}

######################################################################

the following needs to be provided as a secret:

variable "shared_key" {
  type        = string
  description = "Shared key for vpngw connection"
}


######################################################################

Example hub json file:
{
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "idev",
    "cmdb_infra": "123456",
    "cmdb_project": "123456"
  },
  "hub_vnet_address_space": ["10.62.0.0/24"],
  "dns_servers": ["10.62.5.10"],
  "location": "west europe",
  "hub_subnets": {
    "AzureFirewallSubnet": {
      "subnetName": "AzureFirewallSubnet",
      "subnetNamePrefix": "10.62.0.0/26",
      "routeTableNameSuffix": "fw_rt"
    },
    "GatewaySubnet": {
      "subnetName": "GatewaySubnet",
      "subnetNamePrefix": "10.62.0.64/26",
      "routeTableNameSuffix": "vpngw_rt"
    }
  },
  "fw_private_ip_address": "10.62.0.4",
  "vpngw_rt_routes": [
    {
      "routeName": "override_route_to_hub",
      "routeAddressPrefix": "10.62.0.0/24"
    }
  ],
  "fw_policy_proxy_enabled": false,
  "vpngw_bgp_asn": 65301,
  "localgw_networks": {
    "gw1": {
      "local_gateway_address": "147.236.193.60",
      "local_address_space": []
    },
    "gw2": {
      "local_gateway_address": "147.236.194.60",
      "local_address_space": []
    }
  },
  "localgw_bgp_settings": {
    "gw1": {
      "asn_number": 211329,
      "peering_address": "10.65.0.1"
    },
    "gw2": {
      "asn_number": 211329,
      "peering_address": "10.65.0.2"
    }
  },
  "fw_tags": {
    "system_code": "AZFW"
  },
  "fw_policy_tags": {
    "system_code": "fw_policy"
  },
    "log_analytics_workspace_id": "/subscriptions/[subscription-id]/resourceGroups/[resource-group-name]/providers/Microsoft.OperationalInsights/workspaces/[workspace-name]"

}

######################################################################

Example fw_pips.json:

{
  "additional_fw_pips": [
    "fw-pip-1",
    "fw-pip-2",
    "fw-pip-3"
  ]
}