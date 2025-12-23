variable "service_principal_permissions" {
  description = "Route table configuration"
  type = map(object({
    target_kv = string
    key_permissions   = list(string)
    secret_permissions   = list(string)
    storage_permissions   = list(string)
    certificate_permissions   = list(string)
  }))
  default = null
}

variable "object_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}