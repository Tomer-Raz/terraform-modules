# Output the IDs of the Stream Analytics jobs
output "stream_analytics_job_id" {
  description = "The IDs of the Stream Analytics jobs."
  value       = { for k, v in azurerm_stream_analytics_job.job : k => v.id }
}

# Output the names of the Stream Analytics jobs
output "stream_analytics_job_name" {
  description = "The names of the Stream Analytics jobs."
  value       = { for k, v in azurerm_stream_analytics_job.job : k => v.name }
}

# Output the IDs of the Stream Analytics clusters
output "stream_analytics_cluster_id" {
  description = "The IDs of the Stream Analytics clusters."
  value       = { for k, v in azapi_resource.cluster : k => v.id }
}

# Output the names of the Stream Analytics clusters
output "stream_analytics_cluster_name" {
  description = "The names of the Stream Analytics clusters."
  value       = { for k, v in azapi_resource.cluster : k => v.name }
}

# Output the managed identity principal IDs of all Stream Analytics jobs
output "stream_analytics_job_identities" {
  description = "The managed identity principal IDs of all Stream Analytics jobs."
  value       = { for k, v in azurerm_stream_analytics_job.job : k => v.identity[0].principal_id }
}

output "managed_private_endpoint_ids" {
  description = "The IDs of the managed private endpoints."
  value       = try([for endpoint in azurerm_stream_analytics_managed_private_endpoint.managed_private_endpoint : endpoint.id], [])
}

output "managed_private_endpoint_names" {
  description = "The names of the managed private endpoints."
  value       = try([for endpoint in azurerm_stream_analytics_managed_private_endpoint.managed_private_endpoint : endpoint.name], [])
}

output "managed_private_endpoint_target_resource_ids" {
  description = "The target resource IDs of the managed private endpoints."
  value       = try([for endpoint in azurerm_stream_analytics_managed_private_endpoint.managed_private_endpoint : endpoint.target_resource_id], [])
}