Compute Modules

Example:
`
{
  "ampls": {
    "name": "ampls_scope",
    "resource_group_name": "",
    "scoped_resources": [
      {
        "name": "",
        "resource_id": ""
      },
      {
        "name": "",
        "resource_id": ""
      }
    ]
  },
   "ampls_pe": {
    "location": "westeurope",
    "name_convention": {
      "region": "we",
      "name": "i",
      "env": "dev",
      "cmdb_infra": "net",
      "cmdb_project": "2"
    },
    "pe_details": {
      "subnet_id": "/subscriptions/097f24e6-7d2c-439a-b79e-1029c5ed0fa0/resourceGroups/we-idev-2-2-crm-rg/providers/Microsoft.Network/virtualNetworks/we-idev-2-2-crm-spoke-vnet/subnets/we-idev-2-2-secmonitor-subnet",
      "private_service_connection": {
        "name": "pe-ampls",
        "is_manual_connection": false,
        "subresource_names": ["azuremonitor"]
      },
      "private_dns_zone_names": [
        "privatelink.agentsvc.azure-automation.net",
        "privatelink.blob.core.windows.net",
        "privatelink.monitor.azure.com",
        "privatelink.ods.opinsights.azure.com",
        "privatelink.oms.opinsights.azure.com"
      ]
    }
  }
}
`