output "topic_name" {
  description = "The name of the EventGrid Topic"
  value       = azapi_resource.topic.name
}

output "topic_id" {
  description = "The ID of the EventGrid Topic"
  value       = azapi_resource.topic.id
}