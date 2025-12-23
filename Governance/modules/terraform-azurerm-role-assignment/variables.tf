# variable "azure_rbac" {
#   type = list(object({
#     key          = string
#     scope        = string
#     role         = string
#     principal_id = string
#     principal_type = string # "Group", "User", or "ServicePrincipal"
#   }))
# }

variable "azure_rbac" {
  type = list(object({
    key          = string
    principal_id = string
    role         = string
  }))
  description = "List of objects with parameters to create role assignment"
}

variable "targetScope" {
  type = string
}
