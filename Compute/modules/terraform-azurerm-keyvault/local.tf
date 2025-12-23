locals {
  name_prefix = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-${var.name_convention.cmdb_infra}-${var.name_convention.cmdb_project}"
  kv_sp_policies = [
    for kv_key, kv in var.kv_details : [
      for sp_key, sp_id in var.kv_global_admins : {
        kv_key  = kv_key
        service_principal_id  = sp_id
      }
    ]
  ]
  flattened_kv_sp_policies = flatten(local.kv_sp_policies)
  all_key_permissions = [
              "Backup",
              "Create",
              "Decrypt",
              "Delete",
              "Encrypt",
              "Get",
              "Import",
              "List",
              "Purge",
              "Release",
              "Recover",
              "Restore",
              "Sign",
              "UnwrapKey",
              "Update",
              "Verify",
              "WrapKey",
              "SetRotationPolicy",
              "Rotate",
              "GetRotationPolicy"]
  all_secret_permissions = [
              "Backup",
              "Delete",
              "Get",
              "List",
              "Purge",
              "Recover",
              "Restore",
              "Set"]
  all_certificate_permissions = [
              "Backup",
              "Create",
              "Delete",
              "DeleteIssuers",
              "Get",
              "GetIssuers",
              "Import",
              "List",
              "ListIssuers",
              "ManageContacts",
              "ManageIssuers",
              "Purge",
              "Recover",
              "Restore",
              "SetIssuers",
              "Update"]
  all_storage_permissions = [
              "Backup",
              "Delete",
              "DeleteSAS",
              "Get",
              "GetSAS",
              "List",
              "ListSAS",
              "Purge",
              "Recover",
              "RegenerateKey",
              "Restore",
              "Set",
              "SetSAS",
              "Update"]
}