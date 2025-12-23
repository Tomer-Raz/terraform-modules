data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.kv_details

  name                          = "${local.name_prefix}-${each.key}-kv"
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  resource_group_name           = var.resource_group_name
  location                      = var.location
  enabled_for_disk_encryption   = each.value.enabled_for_disk_encryption
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  purge_protection_enabled      = each.value.purge_protection_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  enable_rbac_authorization     = each.value.enable_rbac_authorization
  sku_name                      = each.value.sku_name
  tags                          = each.value.tags

  network_acls {
    bypass         = each.value.bypass
    default_action = "Deny"
  }

  lifecycle {
    ignore_changes = [
      tags, network_acls
    ]
  }
}

resource "azurerm_key_vault_access_policy" "tf_sp_and_kv_admins_kv_access_policy" {
  for_each = { for policy in local.flattened_kv_sp_policies : "${policy.kv_key}-${policy.service_principal_id}" => policy }

  key_vault_id = azurerm_key_vault.kv[each.value.kv_key].id
  object_id    = each.value.service_principal_id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = local.all_key_permissions
  secret_permissions      = local.all_secret_permissions
  storage_permissions     = local.all_storage_permissions
  certificate_permissions = local.all_certificate_permissions
}

resource "azurerm_key_vault_access_policy" "kv_access_policy" {
  for_each = var.service_principal_permissions != null ? var.service_principal_permissions : {}

  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id
  key_vault_id = azurerm_key_vault.kv[each.value.target_kv].id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ tenant_id ]
  }

  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  storage_permissions     = each.value.storage_permissions
  certificate_permissions = each.value.certificate_permissions
}

module "diagnostic_management_kv" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"
  for_each = azurerm_key_vault.kv

  resource_type = "Microsoft.KeyVault/vaults"
  target_id     = each.value.id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}






