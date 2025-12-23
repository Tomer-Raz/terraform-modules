# add to root JSON the following section

{
    "private_dns_zones": {
        "common": {
            "resource_group_name": "<rg name>"
        },
        "zones": {
            "analysis": "privatelink.analysis.windows.net"
            ....
            }
    }
}

# run the module with simular code

module "private_dns_zones" {
  source = "./modules/private_dns_zones"
  data   = "${path.module}/ccoe/private_dns_zones.json"
}
