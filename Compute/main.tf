module "app_service_plan" {
  source            = "./modules/terraform-azurerm-app-service-plan"
  service_plan_list = var.service_plan_list
  name_convention   = var.name_convention
  location          = var.location
  tags              = var.tags
}

module "application_insights" {
  source                        = "./modules/terraform-azurerm-application-insights"
  application_insights_settings = var.application_insights_settings
  name_convention               = var.name_convention
}

module "cognitive_services" {
  source                      = "./modules/terraform-azurerm-clu"
  cognitive_services_settings = var.cognitive_services_settings
  name_convention             = var.name_convention
}

module "eventhub" {
  source              = "./modules/terraform-azurerm-eventhub"
  namespaces          = var.namespaces
  eventhubs           = var.eventhubs
  resource_group_name = var.resource_group_name
  name_convention     = var.name_convention
}

module "keyvault" {
  source          = "./modules/terraform-azurerm-keyvault"
  name_convention = var.name_convention
  kv_details      = var.kv_details
}

module "keyvault_access_policy" {
  source          = "./modules/terraform-azurerm-keyvault-access-policy"
  access_policies = var.access_policies
}

module "keyvault_mngmt" {
  source          = "./modules/terraform-azurerm-keyvault-mngmt"
  key_vault_id = var.kv_id
  secrets      = var.secrets
  certificates = var.certificates
  keys         = var.keys
}

module "linux_function_app" {
  source                  = "./modules/terraform-azurerm-linux-function-app"
  linux_function_app_list = var.linux_function_app_list
  location                = var.location
  tags                    = var.tags
  site_config             = var.site_config
  name_convention         = var.name_convention
}

module "linux_web_app" {
  source            = "./modules/terraform-azurerm-linux-web-app"
  web_app_list      = var.web_app_list
  location          = var.location
  tags              = var.tags
  site_config       = var.site_config
  service_plan_list = var.service_plan_list
  name_convention   = var.name_convention
}

module "log_analytics_workspace" {
  source          = "./modules/terraform-azurerm-log-analytics-workspace"
  workspaces      = var.workspaces
  name_convention = var.name_convention
}

module "private_dns_zone" {
  source            = "./modules/terraform-azurerm-private-dns-zone"
  private_dns_zones = var.private_dns_zone_data
}

module "private_dns_zone_virtual_network_link" {
  source            = "./modules/terraform-azurerm-private-dns-zone-virtual-network-link"
  private_dns_zones = var.private_dns_zone_link_data
}

module "windows_function_app" {
  source                    = "./modules/terraform-azurerm-windows-function-app"
  windows_function_app_list = var.windows_function_app_list
  location                  = var.location
  tags                      = var.tags
  site_config               = var.site_config
  name_convention           = var.name_convention
}

module "windows_web_app" {
  source            = "./modules/terraform-azurerm-windows-web-app"
  web_app_list      = var.web_app_list
  location          = var.location
  tags              = var.tags
  site_config       = var.site_config
  service_plan_list = var.service_plan_list
  name_convention   = var.name_convention
}

module "storage_account" {
  source              = "./modules/terraform-azurerm-storage-account"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  location            = var.location
  name_convention     = var.name_convention

}

module "storage_account_data_lake" {
  source              = "./modules/terraform-azurerm-storage-account-datalake"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  location            = var.location
  name_convention     = var.name_convention

}

module "rbac_assign" {
  source              = "./modules/terraform-azurerm-rbac-assign"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  location            = var.location
}

module "diagnostic_setting" {
  source             = "./modules/terraform-azurerm-diagnostic-setting"
  name_convention    = var.name_convention
  diagnostic_setting = var.diagnostic_setting
}

module "synapse_workspace" {
  source              = "./modules/terraform-azurerm-synapse_workspace"
  resource_group_name = var.resource_group_name
  storage_accounts    = var.storage_accounts
  location            = var.location
  name_convention     = var.name_convention
}

module "synapse_alerts" {
  source                   = "./modules/terraform-azurerm-synapse-alerts"
  synapse_workspace_id     = var.synapse_workspace_id
  primary_blob_endpoint    = var.primary_blob_endpoint
  disabled_alerts          = var.disabled_alerts
  container_name           = var.container_name
  emails                   = var.emails
}



