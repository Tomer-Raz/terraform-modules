# ./modules/Identity/variables.tf

variable "service_principals" {
  description = "List of service principals to create"
  type = list(object({
    name                 = string
    owner_username       = string
    secret_rotation_days = number
    client_secret_name   = string
  }))
}

variable "service_principal_assignments" {
  description = "List of role assignments for service principals"
  type = list(object({
    sp_name              = string
    scope                = string
    role_definition_name = string
  }))
}

variable "user_identities" {
  description = "Map of user-assigned identities to create"
  type        = map(string)
}

variable "resource_group_name" {
  description = "Name of the resource group for user-assigned identities"
  type        = string
}

variable "location" {
  description = "Azure region for user-assigned identities"
  type        = string
}

variable "user_identity_scopes" {
  description = "Map of scopes for each user-assigned identity"
  type        = map(list(string))
}

variable "user_identity_role_definition_name" {
  description = "Map of role definition names for each user-assigned identity"
  type        = map(string)
}