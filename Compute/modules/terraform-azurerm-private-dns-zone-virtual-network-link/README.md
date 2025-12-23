# add to root JSON the following section

{
  "private_dns_zones": {
    "common": {
      "resource_group_name": "we-ipoc-azus-f5-dns-rg"
    },
    "links": {
      "privatelink.analysis.windows.net": [
        "/subscriptions/80adca35-088f-4da0-9f31-384d255120f6/resourceGroups/we-idev-azus-arutzim-rg/providers/Microsoft.Network/virtualNetworks/we-idev-azus-arutzim-vnet",
        "/subscriptions/0b45ef60-0473-42c2-8e17-ef31a085d2b9/resourceGroups/we-idev-azus-crm-rg/providers/Microsoft.Network/virtualNetworks/we-idev-azus-crm-vnet"
      ],
      "privatelink.azuresynapse.net": [
        "/subscriptions/80adca35-088f-4da0-9f31-384d255120f6/resourceGroups/we-idev-azus-arutzim-rg/providers/Microsoft.Network/virtualNetworks/we-idev-azus-arutzim-vnet"
      ]
    }
  }
}

# run the module with simular code

module "private_dns_zones_network_link" {
  source = "./modules/private_dns_zones_network_link"
  data   = "${path.module}/ccoe/private_dns_zones_network_link.json"
}
