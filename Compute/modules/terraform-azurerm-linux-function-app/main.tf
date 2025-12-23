resource "azurerm_linux_function_app" "linux_function_app" {
  for_each = var.linux_function_apps

  name                 = "${local.name_prefix}-${each.value.name}-func"
  location             = var.location
  resource_group_name  = each.value.resource_group_name
  service_plan_id      = each.value.service_plan_id
  storage_account_name = each.value.storage_account_name
  tags                 = var.tags
  https_only           = true

  site_config {
    always_on                              = each.value.site_config.always_on
    app_command_line                       = each.value.site_config.app_command_line
    application_insights_connection_string = each.value.application_insights_connection_string
    use_32_bit_worker                      = each.value.site_config.use_32_bit_worker

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack != null ? [each.value.site_config.application_stack] : []
      content {
        python_version = application_stack.value.python_version
      }
    }
  }

  app_settings = merge(each.value.app_settings, {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  })

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [app_settings, virtual_network_subnet_id]
  }

  storage_uses_managed_identity = true
  public_network_access_enabled = false
}

resource "azurerm_app_service_virtual_network_swift_connection" "app-service-out" {
  for_each = {
    for key, value in var.linux_function_apps : key => value
    if value.subnet_id != null
  }
  app_service_id = azurerm_linux_function_app.linux_function_app[each.key].id
  subnet_id      = each.value.subnet_id
}

module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"

  for_each      = var.linux_function_apps
  resource_type = "Microsoft.Web/sites"
  target_id     = azurerm_linux_function_app.linux_function_app[each.key].id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}

resource "azurerm_function_app_function" "linux_function" {
  for_each = {
    for key, value in var.linux_function_apps : key => value
    if try(value.function, null) != null
  }
  function_app_id = azurerm_linux_function_app.linux_function_app[each.key].id
  name            = each.value.function.name
  language        = each.value.function.language
  test_data       = jsonencode(each.value.function.test_data)
  config_json     = jsonencode(each.value.function.config_json)

  dynamic "file" {
    for_each = var.files
    content {
      name    = file.key
      content = file.value
    }
  }
}
