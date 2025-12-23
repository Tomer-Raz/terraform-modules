

resource "azurerm_storage_account" "storage" {
  for_each = var.storage_accounts

  name                              = "${local.name_prefix}${each.value.name}sa"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  public_network_access_enabled     = each.value.public_network_access_enabled
  account_kind                      = each.value.account_kind
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true
  allow_nested_items_to_be_public   = each.value.allow_nested_items_to_be_public

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = each.value.network_action
    bypass         = each.value.bypass
  }

  dynamic "static_website" {
    for_each = lookup(each.value, "static_website", null) != null ? [1] : []
    content {
      index_document     = lookup(each.value.static_website, "index_document", "")
      error_404_document = lookup(each.value.static_website, "error_404_document", "")
    }
  }

  lifecycle {
    ignore_changes = [tags, customer_managed_key]
  }
}


resource "azurerm_storage_account_customer_managed_key" "storage_cmk" {
  for_each = { for key, account in var.storage_accounts : key => account if lookup(account, "cmk", null) != null }

  storage_account_id = azurerm_storage_account.storage[each.key].id
  key_vault_id       = each.value.cmk.key_vault_id
  key_name           = each.value.cmk.key_name
  key_version        = lookup(each.value.cmk, "key_version", null)

  depends_on = [azurerm_key_vault_access_policy.key_vault_access_policy]
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  for_each = { for key, account in var.storage_accounts : key => account if lookup(account, "cmk", null) != null }

  key_vault_id = each.value.cmk.key_vault_id

  tenant_id = each.value.cmk.tenant_id
  object_id = azurerm_storage_account.storage[each.key].identity[0].principal_id
  key_permissions = ["Get", "List" ,"Decrypt", "Encrypt" ,"UnwrapKey", "WrapKey" ] 

  certificate_permissions =["Get", "List"]

  depends_on = [azurerm_storage_account.storage]
}









module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.192"

  for_each      = var.storage_accounts
  resource_type = "Microsoft.Storage/storageAccounts"
  target_id     = azurerm_storage_account.storage[each.key].id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}

module "diagnostic_management_blob_dev" {
  source   = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version  = "1.0.192"
  for_each = var.storage_accounts

  resource_type = "Microsoft.Storage/storageAccounts/blobServices"
  target_id     = "${azurerm_storage_account.storage[each.key].id}/blobServices/default/"
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
  
}