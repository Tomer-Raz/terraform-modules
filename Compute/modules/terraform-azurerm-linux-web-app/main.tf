module "app_service_plan" {
  source            = "../terraform-azurerm-app-service-plan"
  name_convention   = var.name_convention
  service_plan_list = var.service_plan_list
  location          = var.location
  tags              = var.tags
}

resource "azurerm_linux_web_app" "web_app" {
  for_each            = var.web_app_list
  name                 = "${local.name_prefix}-${each.value.web_app_name}-app"
  location            = var.location
  resource_group_name = each.value.resource_group_name
  service_plan_id     = module.app_service_plan.service_plan_ids[each.key]
  tags                = var.tags

  site_config {
    always_on        = var.site_config.always_on
    app_command_line = var.site_config.app_command_line
  }

  depends_on = [
    module.app_service_plan
  ]
}
