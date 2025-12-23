output "azurerm_monitor_diagnostic_setting_output" {
  value = zipmap(values(azurerm_monitor_diagnostic_setting.diagnostic_setting)[*].name, values(azurerm_monitor_diagnostic_setting.diagnostic_setting)[*])
}
