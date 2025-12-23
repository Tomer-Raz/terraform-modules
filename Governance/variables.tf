
variable "azuread_roles_assignments" {
  description = "List of Azure AD role assignments"
  type = list(object({
    role_template_id    = string
    principal_object_ids = list(string)
  }))
}

variable "azure_rbac" {
  description = "List of Azure RBAC assignments"
  type = list(object({
    key           = string
    scope         = string
    role          = string
    principal_id  = string
  }))
}
