resource "azurerm_policy_definition" "custom_policy_definition" {
  name                = var.name
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = var.display_name
  management_group_id = var.scope
  description         = var.description
  metadata            = var.metadata
  policy_rule         = var.policy_rule
  parameters          = var.parameters
}
