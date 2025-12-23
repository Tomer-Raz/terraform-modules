data "azurerm_management_group" "TEST" {
  name = "Test"
}

data "azurerm_management_group" "lzroot-MG" {
  name = "lzroot-MG"
}

data "azurerm_log_analytics_workspace" "LAW" {
  name                = "we-ydev-msft-secmon-law"
  resource_group_name = "we-ydev-msft-secmon-rg"

  provider = azurerm.Spoke
}

locals {
  # allowed_location_params = (file("allowed_location.json"))
  #   diag_set_params = file("diag_set.json")
  policy_assignments             = jsondecode(file("built_in_policy_assignments.json"))
  policy_assignments_with_params = jsondecode(file("built_in_policy_assignments_with_params.json"))
  custom_policy_assignment       = jsondecode(file("custom_policy_assignment.json"))
  custom_policy_definition       = jsondecode(file("custom_policy_definition.json"))
}


# module "terraform-azurerm-built-in-pol" {
#   source = "./modules/terraform-azurerm-built-in-pol"
#   for_each = {for key,value in local.policy_assignments.built_in_policy :
#               key => value}

#              name = each.value.name
#              display_name = each.value.display_name
#              policy_definition_id = each.value.policy_definition_id
#              scope = data.azurerm_management_group.TEST.id
#              not_scopes = each.value.not_scopes
#              location = var.location
#              parameters = jsonencode(each.value.parameters)
#              message = each.value.non_compliance_message
#              description = each.value.description

# }

# module "terraform-azurerm-built-in-pol-with-params" {
#   source = "./modules/terraform-azurerm-built-in-pol-with-params"
#   for_each = { for key, value in local.policy_assignments_with_params.built_in_policy_with_params :
#   key => value }

#   name                 = each.value.name
#   display_name         = each.value.display_name
#   policy_definition_id = each.value.policy_definition_id
#   scope                = data.azurerm_management_group.TEST.id
#   not_scopes           = each.value.not_scopes
#   location             = var.location
#   parameters           = jsonencode(each.value.parameters)
#   message              = each.value.non_compliance_message
#   description          = each.value.description

#   role_assignment_scope = data.azurerm_management_group.TEST.id
#   definition_name       = each.value.definition_name
# }


module "terraform-azurerm-custom-pol-assign" {
  source = "./modules/terraform-azurerm-custom-pol-assign"
  for_each = { for key, value in local.custom_policy_assignment.custom_policy_assignment :
  key => value }

  name                 = each.value.name
  display_name         = each.value.display_name
  policy_definition_id = each.value.policy_definition_id
  scope                = data.azurerm_management_group.TEST.id
  not_scopes           = each.value.not_scopes
  location             = var.location
  parameters           = jsonencode(each.value.parameters)
  message              = each.value.non_compliance_message
  description          = each.value.description

  role_assignment_scope = data.azurerm_management_group.TEST.id
  definition_name       = each.value.definition_name
  depends_on            = [module.terraform-azurerm-custom-pol-definition]
}

module "terraform-azurerm-custom-pol-definition" {
  source = "./modules/terraform-azurerm-custom-pol-definition"
  for_each = { for key, value in local.custom_policy_definition.custom_policy_definition :
  key => value }

  name         = each.value.name
  display_name = each.value.display_name
  scope        = data.azurerm_management_group.TEST.id
  parameters   = jsonencode(each.value.parameters)
  metadata     = jsonencode(each.value.metadata)
  policy_rule  = jsonencode(each.value.policy_rule)
  description  = each.value.description
}


