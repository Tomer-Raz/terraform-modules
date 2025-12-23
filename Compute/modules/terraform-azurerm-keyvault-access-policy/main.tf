data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  for_each = var.service_principal_permissions != null ? var.service_principal_permissions : {}

  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.object_id
  key_vault_id = var.key_vault_id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tenant_id ]
  }

  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  storage_permissions     = each.value.storage_permissions
  certificate_permissions = each.value.certificate_permissions
}
