output "windows_web_app_ids" {
  value = { for e, app in azurerm_windows_web_app.web_app : e => app.id }
}