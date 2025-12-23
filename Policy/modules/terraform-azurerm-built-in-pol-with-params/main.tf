resource "azurerm_management_group_policy_assignment" "built" {
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
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_policy_definition" "definition_data" {
  name = var.definition_name
}

locals {
  role_definition_ids = data.azurerm_policy_definition.definition_data.role_definition_ids
  role_definitions = [
    for value in local.role_definition_ids : {
      role_id = element(split("/", value), (length(split("/", value)) > 0 ?length(split("/", value)) -1 : 0 ))
      definition_id = "${value}"
    }
  ]
}


resource "azurerm_role_assignment" "role_assignment" {
  # count              = length(local.role_definition_ids)
  for_each = { for defenition in local.role_definitions: defenition.role_id => defenition}
  scope              = var.role_assignment_scope
  role_definition_id = each.value.definition_id
  principal_id       = azurerm_management_group_policy_assignment.built.identity[0].principal_id
}

resource "azurerm_management_group_policy_remediation" "pol_remediation" {
  name                 = "rem_${var.name}"
  management_group_id  = var.scope
  policy_assignment_id = azurerm_management_group_policy_assignment.built.id
}




