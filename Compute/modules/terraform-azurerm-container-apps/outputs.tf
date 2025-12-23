output "container_app_ids" {
  description = "IDs of the deployed Container Apps"
  value       = { for name, app in azurerm_container_app.aca : name => app.id }
}