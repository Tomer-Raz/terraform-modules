output "user_identities" {
  description = "All attributes of the user identities"
  value       = { for k, v in azurerm_user_assigned_identity.user_identity : k => v }
}

output "idenity_id" {
  value = {
    for user_id in azurerm_user_assigned_identity.user_identity :
    user_id.name => user_id.id
  }
}

output "idenity_client_id" {
  value = {
    for user_id in azurerm_user_assigned_identity.user_identity :
    user_id.name => user_id.client_id
  }
}

output "idenity_principal_id" {
  value = {
    for user_id in azurerm_user_assigned_identity.user_identity :
    user_id.name => user_id.principal_id
  }
} 
