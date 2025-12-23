module "azuread_role_assignment" {
  source = "./modules/terraform-azuread-role-assignment"
  roles_assignments = var.azuread_roles_assignments
}

module "azurerm_role_assignment" {
  source = "./modules/terraform-azurerm-role-assignment"
  azure_rbac = var.azure_rbac
}

