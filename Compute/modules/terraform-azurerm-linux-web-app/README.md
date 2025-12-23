---------------------
example of main.tf:

locals {
  config = jsondecode(file("${path.module}/configuration.json"))
}

module "terraform-azurerm-linux-web-app" {
  source = "./terraform-azurerm-linux-web-app"

  service_plan_list = local.config.service_plan_list
  web_app_list      = local.config.web_app_list
  location          = local.config.location
  tags              = local.config.tags
  site_config       = local.config.site_config
}

-------------------
example of configuration:

{
  "location": "West Europe",
  "tags": {
    "project": "example"
  },
  "service_plan_list": {
    "plan12": {
      "resource_group_name": "tomer-example-rg-1",
      "sku_name": "B1",
      "os_type": "Linux"
    },
    "plan13": {
      "resource_group_name": "tomer-example-rg-1",
      "sku_name": "B1",
      "os_type": "Linux"
    }
  },
  "web_app_list": {
    "plan12": {
      "resource_group_name": "tomer-example-rg-1",
      "web_app_name": "web-app-example10"
    },
    "plan13": { 
      "resource_group_name": "tomer-example-rg-1",
      "web_app_name": "web-app-example11"
    }
  },
  "site_config": {
    "always_on": true,
    "app_command_line": ""
  }
}
  
  ------------------
  Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
  ------------------