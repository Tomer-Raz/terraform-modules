resource "azurerm_application_insights" "app_insights" {
  for_each                            = var.application_insights_settings
  name                                = "${local.name_prefix}-${each.value.name}-appi"
  location                            = var.location
  resource_group_name                 = each.value.resource_group_name
  application_type                    = each.value.application_type
  daily_data_cap_in_gb                = each.value.daily_data_cap_in_gb != null ? each.value.daily_data_cap_in_gb : 50
  retention_in_days                   = each.value.retention_in_days != null ? each.value.retention_in_days : 7
  workspace_id                        = each.value.workspace_id
  local_authentication_disabled       = each.value.local_authentication_disabled
  internet_ingestion_enabled          = each.value.internet_ingestion_enabled
  internet_query_enabled              = each.value.internet_query_enabled
  tags                                = var.tags
  force_customer_storage_for_profiler = true
}

