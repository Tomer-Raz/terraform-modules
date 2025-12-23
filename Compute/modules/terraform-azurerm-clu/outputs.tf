
output "cognitive_accounts" {
  value       = azurerm_cognitive_account.cognitive_account
  description = "The whole object created"
}

output "access_keys" {
  value = { for k, v in azurerm_cognitive_account.cognitive_account : k => {
    primary   = v.primary_access_key
    secondary = v.secondary_access_key
  } }

  sensitive   = true
  description = "both keys of the cognitive service accounts"
}