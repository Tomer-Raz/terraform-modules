---------------------
example of main.tf:

locals {
  config = jsondecode(file("${path.module}/configuration.json"))
}

module "terraform-azurerm-app-service-plan" {
  source = "./terraform-azurerm-app-service-plan"

  location           = local.config.location
  tags               = local.config.tags
  service_plan_list  = local.config.service_plan_list
}
-------------------
example of configuration:

{
    "location": "West Europe",
    "tags": {
      "project": "example"
    },
    "service_plan_list": {
      "plan1": {
        "resource_group_name": "tomer-example-rg-1",
        "sku_name": "F1",
        "os_type": "Linux"
      },
      "plan2": {
        "resource_group_name": "tomer-example-rg-1",
        "sku_name": "B1",
        "os_type": "Windows"
      }
    }
  }
  ------------------
  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
  ------------------