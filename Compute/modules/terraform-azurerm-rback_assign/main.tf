resource "azurerm_role_assignment" "rbac_roles" {
  scope                = var.target_resource_rbac # "The scope at which RBAC permissions will be assigned (e.g., resource group, subscription, etc.)."
  principal_id         = var.identity_id_rbac # "The principal ID of the identity to which RBAC permissions will be assigned."
  role_definition_name = var.rbac_role_name # "The name of the RBAC role to be assigned to the specified identity."
}