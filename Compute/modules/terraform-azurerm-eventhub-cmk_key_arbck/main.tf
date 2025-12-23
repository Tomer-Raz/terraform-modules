resource "azurerm_eventhub_namespace" "namespace" {
  for_each                      = var.namespaces
  name                          = "${local.name_prefix}-${each.value.name}-evhns"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = each.value.sku
  capacity                      = each.value.capacity
  auto_inflate_enabled          = each.value.auto_inflate_enabled
  maximum_throughput_units      = each.value.maximum_throughput_units
  local_authentication_enabled  = each.value.local_authentication_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  # tags                          = var.tags
  identity {
    type = "SystemAssigned"
  }
}

# add cmk
resource "azurerm_eventhub_namespace_customer_managed_key" "encryption" {
  for_each              = var.enable_encryption ? var.namespaces : {}
  eventhub_namespace_id = azurerm_eventhub_namespace.namespace[each.key].id
  key_vault_key_ids     = var.key_vault_key_ids
  depends_on            = [azurerm_key_vault_access_policy.eventhub_encryption_policy]
}

#cmk pramision 
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "eventhub_encryption_policy" {
  for_each     = var.enable_encryption ? var.namespaces : {}
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_eventhub_namespace.namespace[each.key].identity[0].principal_id
  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
  depends_on = [azurerm_eventhub_namespace.namespace, data.azurerm_client_config.current]
}

resource "azurerm_eventhub" "eventhub" {
  for_each            = var.eventhubs
  name                = each.value.special_cmdb == true ? "${local.name_prefix_special}-${each.value.name}-evh" : "${local.name_prefix}-${each.value.name}-evh"
  namespace_name      = azurerm_eventhub_namespace.namespace[each.value.namespace_name].name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partitions
  message_retention   = each.value.message_retention

  dynamic "capture_description" {
    for_each = each.value.capture_enabled ? [1] : []
    content {
      enabled  = each.value.capture_enabled
      encoding = each.value.capture_encoding
      destination {
        name                = "EventHubArchive.AzureBlockBlob"
        archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
        blob_container_name = each.value.blob_container_name
        storage_account_id  = each.value.storage_account_id
        #storage_managed_identity_authorization = true
      }
    }
  }
  depends_on = [azurerm_eventhub_namespace_customer_managed_key.encryption]
}

resource "azurerm_eventhub_consumer_group" "consumer_group" {
  for_each            = var.consumer_groups
  name                = each.value.name
  eventhub_name       = azurerm_eventhub.eventhub[each.value.eventhub_name].name
  namespace_name      = azurerm_eventhub_namespace.namespace[each.value.namespace_name].name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "rbac_roles" {
  for_each = {
    for eh_key, eh_value in var.eventhubs :
    eh_key => {
      storage_account_id = eh_value.storage_account_id
      principal_id       = azurerm_eventhub_namespace.namespace[eh_value.namespace_name].identity[0].principal_id
    } if lookup(eh_value, "capture_enabled", false) == true &&
    lookup(eh_value, "storage_account_id", null) != null
  }

  scope                = each.value.storage_account_id
  principal_id         = each.value.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  depends_on           = [azurerm_eventhub_namespace.namespace]
}

# resource "time_sleep" "delay_after_rbac" {
#   for_each = azurerm_role_assignment.rbac_roles
#   create_duration = "60s"

#   depends_on = [azurerm_role_assignment.rbac_roles]
# }

module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.213"

  for_each      = var.namespaces
  resource_type = "Microsoft.EventHub/Namespaces"
  target_id     = azurerm_eventhub_namespace.namespace[each.key].id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}