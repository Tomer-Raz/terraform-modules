module "service_principal" {
  source             = "./modules/terraform-azurerm-service_principal"
  service_principals = var.service_principals
  assignments        = var.service_principal_assignments
}

module "user_identity" {
  source               = "./modules/terraform-azurerm-user-identity"
  user_identities      = var.user_identities
  resource_group_name  = var.resource_group_name
  location             = var.location
  scopes               = var.user_identity_scopes
  role_definition_name = var.user_identity_role_definition_name
}