output "synapse_id" {
  value = azurerm_synapse_workspace.synapse.id
}

output "private_link_hub_id" {
  value = azurerm_synapse_private_link_hub.hub.id
}

output "spark_pool_ids" {
  description = "The IDs of the Synapse Spark pools"
  value       = { for k, v in azurerm_synapse_spark_pool.synapse : k => v.id }
}

output "spark_pool_names" {
  description = "The names of the Synapse Spark pools"
  value       = { for k, v in azurerm_synapse_spark_pool.synapse : k => v.name }
}