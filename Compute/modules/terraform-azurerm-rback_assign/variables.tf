variable "target_resource_rbac" {
  description = "The Azure resource to which RBAC permissions will be assigned (e.g., resource group, subscription, etc.)."
  type        = string
}

variable "identity_id_rbac" {
  description = "The ID of the identity to which RBAC permissions will be assigned."
  type        = string
}

variable "rbac_role_name" {
  description = "The name of the RBAC role to be assigned to the specified identity."
  type        = string
}