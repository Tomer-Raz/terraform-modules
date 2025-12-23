resource "azuread_directory_role_assignment" "role_assignment" {
  for_each = {
    for idx, obj in flatten([
      for ra in var.roles_assignments : [
        for principal_id in ra.principal_object_ids : {
          role_template_id    = ra.role_template_id
          principal_object_id = principal_id
        }
      ]
    ]) : "${obj.role_template_id}-${obj.principal_object_id}" => obj
  }

  principal_object_id = each.value.principal_object_id
  role_id             = each.value.role_template_id
}