# output "primary_access_key" {
#   description = "the access key created"
#   value       = azurerm_storage_account.func_storage.primary_access_key
# } 

output "principal_id" {
  value = azurerm_storage_account.synapse_storage.identity.0.principal_id
}

output "datalake_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.synapse_storage.id
}

output "storage_account_id" {
  value = azurerm_storage_account.synapse_storage.id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.synapse_storage.primary_blob_endpoint
}

output "storage_container_paths" {
  value = { for container in azurerm_storage_container.container : container.name => "${azurerm_storage_account.synapse_storage.primary_blob_endpoint}${container.name}" }
}

output "storage_container_names" {
  value = { for container in azurerm_storage_container.container : container.name => container.id }
}