module "diagnostic_setting" {
  source  = "source/modules/azurerm//modules/Compute/modules/terraform-azurerm-diagnostic-setting"
  version = "1.0.192"
  for_each = local.diagnostics_group

  diagnostic_setting = [
    {
      name               = "${var.resource_type}-${each.key}-diag"
      target_resource_id = var.target_id
      law_id             = each.key == "ops" ? var.opsmon_law_id : var.secmon_law_id
      type               = each.key
      enabled_logs = [
        for item in each.value :
        { category = item.name }
        if item.category == "logs" && item.resource_type == var.resource_type
      ]
      metrics = [
        for item in each.value :
        { category = item.name }
        if item.category == "metrics" && item.resource_type == var.resource_type
      ]
    }
  ]
  name_convention = var.name_convention
}