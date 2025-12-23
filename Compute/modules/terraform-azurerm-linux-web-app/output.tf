output "linux_web_app_ids" {
  value = { for e, app in azurerm_linux_web_app.web_app : e => app.id }
}