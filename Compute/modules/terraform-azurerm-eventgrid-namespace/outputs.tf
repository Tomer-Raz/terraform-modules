output "azurerm_eventgrid_namespace" {
  value       = { for k, v in azurerm_eventgrid_namespace.event_grid : k => v }
}

output "eventgrid_namespace_ids" {
  description = "Map of event grid topic names"
  value = {
    for k, v in azurerm_eventgrid_namespace.event_grid : k => v.id
  }
}

output "eventgrid_namespaces" {
  description = "Map of event grid topics with their names and IDs"
  value = {
    for k, v in azurerm_eventgrid_namespace.event_grid : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "eventgrid_namespaces_names" {
  description = "Map of event grid topic names"
  value = {
    for k, v in azurerm_eventgrid_namespace.event_grid : k => v.name
  }
}