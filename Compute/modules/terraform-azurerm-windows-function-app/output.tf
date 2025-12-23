output "function_app_ids" {
  value = { for k, v in azurerm_windows_function_app.windows_function_app : k => v.id }
  description = "The IDs of the Windows Function Apps"
}

output "function_app_default_hostnames" {
  value = { for k, v in azurerm_windows_function_app.windows_function_app : k => v.default_hostname }
  description = "The default hostnames of the Windows Function Apps"
}

output "function_app_details" {
  value = { for func in azurerm_windows_function_app.windows_function_app : func.name => func}
  description = "Details of the Function Apps"
}