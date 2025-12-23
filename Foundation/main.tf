module "resource_groups" {
  source          = "./modules/terraform-azurerm-rg"
  resource_groups = var.resource_groups
  name_convention = var.name_convention
}

module "management_group" {
  source = "./modules/terraform-azurerm-management-group"
  data   = var.management_group_data
}

module "subscription" {
  source               = "./modules/terraform-azurerm-subscription"
  subscription_details = var.subscription_details
  name_convention      = var.name_convention
  tags                 = var.tags
}

module "diagnostic_management" {
  source          = "./modules/terraform-azurerm-diagnostic-management"
  resource_type   = var.resource_type
  target_id       = var.target_id
  secmon_law_id   = var.secmon_law_id
  opsmon_law_id   = var.opsmon_law_id
  name_convention = var.name_convention
}


module "azuread_group" {
  source = "./modules/terraform-azuread-group"
  groups = var.groups
}
