# # Data source for Azure AD Groups
# data "azuread_group" "name" {
#   for_each = {
#     for permission in var.azure_rbac : permission.key => permission
#     if permission.principal_type == "Group"
#   }

#   display_name     = each.value.principal_id
#   security_enabled = true
# }

# # Data source for Azure AD Users
# data "azuread_user" "name" {
#   for_each = {
#     for permission in var.azure_rbac : permission.key => permission
#     if permission.principal_type == "User"
#   }

#   user_principal_name = each.value.principal_id
# }

# # Data source for Azure AD Service Principals
# data "azuread_service_principal" "name" {
#   for_each = {
#     for permission in var.azure_rbac : permission.key => permission
#     if permission.principal_type == "ServicePrincipal"
#   }

#   display_name = each.value.principal_id
# }

# # Role Assignment Resource
# resource "azurerm_role_assignment" "this" {
#   for_each = {
#     for permission in var.azure_rbac : "${permission.key}-${permission.role}" => permission
#     if permission.key != null
#   }

#   scope                = each.value.scope
#   role_definition_name = each.value.role
#   principal_id = lookup({
#     "Group"           = try(data.azuread_group.name[each.value.key].object_id, each.value.principal_id),
#     "User"            = try(data.azuread_user.name[each.value.key].object_id, each.value.principal_id),
#     "ServicePrincipal" = try(data.azuread_service_principal.name[each.value.key].object_id, each.value.principal_id)
#   }, each.value.principal_type, each.value.principal_id)
# }

resource "azurerm_role_assignment" "this" {
  for_each = {
    for permission in var.azure_rbac : "${permission.key}-${permission.role}" => permission
    if permission.key != null
  }

  scope                = var.targetScope
  role_definition_name = each.value.role
  principal_id         = each.value.principal_id
}
