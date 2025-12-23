output "private_endpoint_ids" {
  description = "IDs of the Private Endpoints."
  value       = { for pe in azurerm_private_endpoint.private_endpoint : pe.name => pe.id }
}

output "private_endpoint_details" {
  description = "Details of the Private Service Connections."
  value       = { for pe in azurerm_private_endpoint.private_endpoint : pe.name => pe}
}

output "private_endpoint_private_ip_addresses" {
  description = "Private IP addresses assigned to each Private Endpoint."
  value       = { for pe in azurerm_private_endpoint.private_endpoint : pe.name => length(pe.ip_configuration) > 0 ? pe.ip_configuration[0].private_ip_address : null }
}
