locals {
  config_activity_log_alerts                = jsondecode(file("./activity_log_alerts/config.json"))
  config_action_groups                      = jsondecode(file("./action_groups/config.json"))
  config_log_alerts                         = jsondecode(file("./log_alerts/config.json"))
  config_metric_alerts                      = jsondecode(file("./metric_alerts/config.json"))
  config_ampls                              = jsondecode(file("./ampls/config.json"))
  config_log_analytics_workspace_onboarding = jsondecode(file("./sentinel_alerts/log_analytics_workspace_onboarding/config.json"))
  config_ms_security_incident               = jsondecode(file("./sentinel_alerts/ms_security_incident/config.json"))

  action_group_ids = module.action_groups.action_group_ids

  activity_log_alert = [
    for value in local.config_activity_log_alerts.activity_log_alert : merge([value, {
      resource_group_name = azurerm_resource_group.gal_test.name  #output
      resource_id         = azurerm_storage_account.to_monitor.id #output
      action_group_id     = local.action_group_ids[value.action_group_identifier]
    }]...)
  ]

  action_groups = [
    for value in local.config_action_groups.action_groups : merge([value, {
      resource_group_name = azurerm_resource_group.gal_test.name #output
    }]...)
  ]

  metric_alert = [
    for value in local.config_metric_alerts.metric_alert : merge([value, {
      resource_group_name = azurerm_resource_group.gal_test.name  #output
      resource_id         = azurerm_storage_account.to_monitor.id #output
      action_group_id     = local.action_group_ids[value.action_group_identifier]
    }]...)
  ]

  scheduled_query_rules_alert = [
    for value in local.config_log_alerts.scheduled_query_rules_alert : merge([value, {
      resource_group_name = azurerm_resource_group.gal_test.name #output
      action_group_id     = local.action_group_ids[value.action_group_identifier]
      location            = azurerm_resource_group.gal_test.location
      data_source_id      = azurerm_storage_account.to_monitor.id
    }]...)
  ]

  dashboards = {
    resource_group_name = azurerm_resource_group.gal_test.name
    location            = azurerm_resource_group.gal_test.location
  }

  ampls = {
    name                = local.config_ampls.ampls.name
    resource_group_name = azurerm_resource_group.gal_test.name
    scoped_resources    = local.config_ampls.ampls.scoped_resources
  }
}

module "action_groups" {
  source        = "./action_groups"
  action_groups = local.action_groups
}

module "activity_log_alert" {
  source             = "./activity_log_alerts"
  activity_log_alert = local.activity_log_alert
}

module "metric_alert" {
  source       = "./metric_alerts"
  metric_alert = local.metric_alert
}

module "scheduled_query_rules_alert" {
  source                      = "./log_alerts"
  scheduled_query_rules_alert = local.scheduled_query_rules_alert
}

module "dashboards" {
  source     = "./dashboards"
  dashboards = local.dashboards
}

module "ampls" {
  source = "./ampls"
  ampls  = local.ampls
}

module "sentinel_onboarding" {
  source               = "./sentinel_alerts/log_analytics_workspace_onboarding"
  workspace_onboarding = local.config_log_analytics_workspace_onboarding.workspace_onboarding
}

module "azurerm_sentinel_alert_rule_ms_security_incident" {
  source            = "./sentinel_alerts/ms_security_incident"
  security_incident = local.config_ms_security_incident.security_incident
  depends_on        = [module.sentinel_onboarding]
}






####################################################################################################
# Resource to monitor
####################################################################################################

resource "azurerm_resource_group" "gal_test" {
  name     = "gal_test"
  location = "West Europe"
}


resource "azurerm_log_analytics_workspace" "gal_test_workspace" {
  name                = "galtestworkspace"
  location            = azurerm_resource_group.gal_test.location
  resource_group_name = azurerm_resource_group.gal_test.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_workspace" "gal_test_workspace1" {
  name                = "galtestworkspace1"
  location            = azurerm_resource_group.gal_test.location
  resource_group_name = azurerm_resource_group.gal_test.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_storage_account" "to_monitor" {
  name                     = "galtestydygreen"
  resource_group_name      = azurerm_resource_group.gal_test.name
  location                 = azurerm_resource_group.gal_test.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_monitor_diagnostic_setting" "storage_diagnostics" {
  name               = "storage-diagnostic-setting"
  target_resource_id = azurerm_storage_account.to_monitor.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.gal_test_workspace.id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_key_vault" "example" {
  name                     = "uniqueexamplekv1234" # Use a unique name here
  location                 = azurerm_resource_group.gal_test.location
  resource_group_name      = azurerm_resource_group.gal_test.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true

  soft_delete_retention_days  = 7
  enabled_for_disk_encryption = true

  enable_rbac_authorization = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  name                       = "kv-diagnostic-setting"
  target_resource_id         = azurerm_key_vault.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.gal_test_workspace.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_application_insights" "example" {
  name                = "galtest-appinsights" // Replace with your desired name
  location            = azurerm_resource_group.gal_test.location
  resource_group_name = azurerm_resource_group.gal_test.name
  application_type    = "web"
  tags = {
    environment = "ydygreen"
  }
}

resource "azurerm_application_insights" "example1" {
  name                = "galtest-appinsights1" // Replace with your desired name
  location            = azurerm_resource_group.gal_test.location
  resource_group_name = azurerm_resource_group.gal_test.name
  application_type    = "web"
  tags = {
    environment = "ydygreen"
  }
}


