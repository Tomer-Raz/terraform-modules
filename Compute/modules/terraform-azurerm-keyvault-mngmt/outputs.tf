output "secrets_ids" {
  value = {
    for secret in azurerm_key_vault_secret.secrets : secret.name => {
      id                    = secret.id
      resource_id           = secret.resource_id
      resource_versionless_id = secret.resource_versionless_id
      version               = secret.version
      versionless_id        = secret.versionless_id
    }
  }
}



output "certificates_attributes" {
  value = {
    for cert in azurerm_key_vault_certificate.certificates : cert.name => {
      id                          = cert.id
      secret_id                    = cert.secret_id
      version                      = cert.version
      versionless_id               = cert.versionless_id
      versionless_secret_id        = cert.versionless_secret_id
      certificate_data             = cert.certificate_data
      certificate_data_base64      = cert.certificate_data_base64
      thumbprint                   = cert.thumbprint
      certificate_attribute        = cert.certificate_attribute
      resource_manager_id          = cert.resource_manager_id
      resource_manager_versionless_id = cert.resource_manager_versionless_id
    }
  }
}


output "keys_attributes" {
  value = {
    for key in azurerm_key_vault_key.keys : key.name => {
      id                          = key.id
      resource_id                 = key.resource_id
      resource_versionless_id     = key.resource_versionless_id
      version                     = key.version
      versionless_id              = key.versionless_id
      n                           = key.n
      e                           = key.e
      x                           = key.x
      y                           = key.y
      public_key_pem              = key.public_key_pem
      public_key_openssh          = key.public_key_openssh
    }
  }
}
