---------------------
example of main.tf:

locals {
  config = jsondecode(file("${path.module}/configuration.json"))
}

module "terraform-azurerm-windows-web-app" {
  source = "./terraform-azurerm-windows-web-app"

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
    "plan14": {
      "resource_group_name": "tomer-example-rg-1",
      "sku_name": "B1",
      "os_type": "windows"
    },
    "plan15": {
      "resource_group_name": "tomer-example-rg-1",
      "sku_name": "B1",
      "os_type": "windows"
    }
  },
  "web_app_list": {
    "plan14": {
      "resource_group_name": "tomer-example-rg-1",
      "web_app_name": "web-app-example10"
    },
    "plan15": { 
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