resource "azurerm_management_group_policy_assignment" "built_in_pol" {
  name                 = var.name
  display_name         = var.display_name
  policy_definition_id = var.policy_definition_id
  management_group_id  = var.scope
  not_scopes           = var.not_scopes
  parameters           = var.parameters
  location             = var.location
  description          = var.description
  non_compliance_message {
    content = var.message
  }
}

