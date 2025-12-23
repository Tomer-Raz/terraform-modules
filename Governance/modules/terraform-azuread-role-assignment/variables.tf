variable "roles_assignments" {
  description = "A list of role assignments, where each item is an object containing a role_template_id and a list of principal_object_ids"
  type = list(object({
    role_template_id     = string
    principal_object_ids = list(string)
  }))
}