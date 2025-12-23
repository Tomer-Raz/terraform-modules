output "storage_account_names" {
  value = {
    for k, v in azurerm_storage_account.storage : k => v.name
  }
}

output "storage_account_ids" {
  value = {
    for k, v in azurerm_storage_account.storage : k => v.id
  }
}

output "primary_access_keys" {
  value = {
    for k, v in azurerm_storage_account.storage : k => v.primary_access_key
  }
  sensitive = true
}

output "primary_blob_endpoints" {
  value = {
    for k, v in azurerm_storage_account.storage : k => v.primary_blob_endpoint
  }
}

output "azurerm_storage_account_customer_managed_key" {
  description = "All attributes of azurerm_storage_account_customer_managed_key"
  value       = azurerm_storage_account_customer_managed_key.storage_cmk
}

output "azurerm_storage_account" {
    description = "All attributes of azurerm_storage_account"
  value =azurerm_storage_account.storage
  
}