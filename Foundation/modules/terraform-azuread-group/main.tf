resource "azuread_group" "group" {
  for_each         = var.groups
  display_name     = "c-aaad-${each.value.name}updated-d-e-aaad-${each.value.cmdb}-${each.value.role_name}"
  security_enabled = true
  # members          = each.value.members // terraform does not support PIM for groups - can't assign direct users to group!
}