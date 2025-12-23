output "kv_id" {
  description = "map of key vault names to the IDs"
  value = {
    for key, kv in azurerm_key_vault.kv :
    key => kv.id
  }
}

output "kv_uri" {
  description = "map of key vault names to the URIs"
  value = {
    for key, kv in azurerm_key_vault.kv :
    key => kv.vault_uri
  }
}

output "kvs" {
  value       = { for k, v in azurerm_key_vault.kv : k => v }
}