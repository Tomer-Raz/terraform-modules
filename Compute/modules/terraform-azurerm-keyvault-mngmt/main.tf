resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets != null ? var.secrets : {}

  name            = each.key
  value           = each.value.value
  expiration_date = each.value.expiration_date
  key_vault_id    = var.key_vault_id
  content_type    = lookup(each.value, "content_type", null)
  tags            = lookup(each.value, "tags", null)
  not_before_date = lookup(each.value, "not_before_date", null)

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_key_vault_certificate" "certificates" {
  for_each = var.certificates != null ? var.certificates : {}

  name         = each.key
  key_vault_id = var.key_vault_id

  dynamic "certificate" {
    for_each = each.value.certificate != null ? [each.value.certificate] : []

    content {
      contents = filebase64(lookup(certificate.value, "contents", ""))
      password = lookup(certificate.value, "password", "")
    }
  }

  dynamic "certificate_policy" {
    for_each = each.value.certificate_policy != null ? [each.value.certificate_policy] : []

    content {
      dynamic "issuer_parameters" {
        for_each = certificate_policy.value.issuer_parameters != null ? [certificate_policy.value.issuer_parameters] : []

        content {
          name = lookup(issuer_parameters.value, "name", "")
        }
      }

      dynamic "key_properties" {
        for_each = certificate_policy.value.key_properties != null ? [certificate_policy.value.key_properties] : []

        content {
          exportable = lookup(key_properties.value, "exportable", "")
          key_size   = lookup(key_properties.value, "key_size", 0)
          key_type   = lookup(key_properties.value, "key_type", "")
          reuse_key  = lookup(key_properties.value, "reuse_key", "")
        }
      }

      dynamic "secret_properties" {
        for_each = certificate_policy.value.secret_properties != null ? [certificate_policy.value.secret_properties] : []

        content {
          content_type = lookup(secret_properties.value, "content_type", "")
        }
      }
    }
  }
}

resource "azurerm_key_vault_key" "keys" {
  for_each = var.keys != null ? var.keys : {}


  name            = each.key
  key_vault_id    = var.key_vault_id
  key_size        = lookup(each.value, "key_size", null)
  key_type        = lookup(each.value, "key_type", null)
  key_opts        = lookup(each.value, "key_opts", null)
  expiration_date = lookup(each.value, "expiration_date", null)

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy != null ? [each.value.rotation_policy] : []

    content {
      expire_after         = try(rotation_policy.value.expire_after, null)
      notify_before_expiry = try(rotation_policy.value.notify_before_expiry, null)

      dynamic "automatic" {
        for_each = rotation_policy.value.automatic != null ? [rotation_policy.value.automatic] : []

        content {
          time_after_creation = try(automatic.value.time_after_creation, null)
          time_before_expiry  = try(automatic.value.time_before_expiry, null)
        }
      }
    }
  }
}




