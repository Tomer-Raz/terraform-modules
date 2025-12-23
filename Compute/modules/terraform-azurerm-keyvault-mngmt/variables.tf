variable "key_vault_id" {
  description = "The ID of the Azure Key Vault where secrets, keys, and certificates will be stored."
  type        = string
}

variable "secrets" {
  description = "The Key Vault configuration"
  type = map(object({
    value           = optional(string)
    content_type    = optional(string)
    not_before_date = optional(string)
    tags            = optional(map(string))
  }))
  default = {}
}

variable "certificates" {
  description = "Map of certificate configurations"
  type = map(object({
    certificate = optional(object({
      contents = optional(string)
      password = optional(string)
      expires = optional(string)
    }))
    certificate_policy = optional(object({
      issuer_parameters = optional(object({
        name = optional(string)
      }))
      key_properties = optional(object({
        exportable = optional(bool)
        key_size   = optional(number)
        key_type   = optional(string)
        reuse_key  = optional(bool)
      }))
      lifetime_actions = optional(list(object({
        action = object({
          action_type = optional(string)
        })
        trigger = object({
          days_before_expiry = optional(number)
        })
      })))
      secret_properties = optional(object({
        content_type = optional(string)
      }))
      x509_certificate_properties = optional(object({
        extended_key_usage = optional(list(string))
        key_usage          = optional(list(string))
        subject_alternative_names = optional(object({
          dns_names = optional(list(string))
        }))
        subject            = optional(string)
        validity_in_months = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "keys" {
  description = "Map of key configurations"
  type = map(object({
    key_size        = optional(number)
    key_type        = optional(string)
    key_opts        = optional(list(string))
    expiration_date = optional(string)
    rotation_policy = optional(object({
      expire_after         = optional(string)
      notify_before_expiry = optional(string)
      action = optional(object({
        time_after_creation = optional(string)
        time_before_expiry  = optional(string)
      }))
    }))
  }))
  default = {}
}



