output "function_app_ids" {
  value = { for k, v in azurerm_linux_function_app.linux_function_app : k => v.id }
  description = "The IDs of the linux Function Apps"
}

output "function_app_default_hostnames" {
  value = { for k, v in azurerm_linux_function_app.linux_function_app : k => v.default_hostname }
  description = "The default hostnames of the linux Function Apps"
}