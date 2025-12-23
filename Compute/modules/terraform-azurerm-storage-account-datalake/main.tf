data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "synapse_storage" {
  
  name                              = "${local.name_prefix}${var.sa_name}sa"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = "Standard"
  account_replication_type          = var.account_replication_type
  public_network_access_enabled     = true
  account_kind                      = "StorageV2"
  shared_access_key_enabled         = false #Set to true when running connector
  is_hns_enabled                    = true
  infrastructure_encryption_enabled = true
  allow_nested_items_to_be_public   = false

  identity {
    identity_ids = tolist([var.identity_id])
    type         = "UserAssigned"
  }

  customer_managed_key {
    key_vault_key_id          = var.kv_key_versionless_id
    user_assigned_identity_id = var.identity_id
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]

    private_link_access {
            endpoint_resource_id = "/subscriptions/${data.azurerm_client_config.current.tenant_id}/providers/Microsoft.Security/datascanners/storageDataScanner"
            endpoint_tenant_id   = data.azurerm_client_config.current.subscription_id
    }
  }

  lifecycle {
    ignore_changes = [tags, customer_managed_key, network_rules]
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each = var.pe_details != null ? var.pe_details : {}

  name                = "${local.pe_name_prefix}-${each.key}-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  ip_configuration {
    name               = each.value.ip_configuration.name
    private_ip_address = each.value.ip_configuration.private_ip_address
    subresource_name   = each.value.ip_configuration.subresource_name
    member_name        = each.value.ip_configuration.member_name
  }

  private_service_connection {
    name                           = "${each.value.private_service_connection.name}-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.synapse_storage.id
    is_manual_connection           = each.value.private_service_connection.is_manual_connection
    subresource_names              = each.value.private_service_connection.subresource_names
  }

  private_dns_zone_group {
    name                 = "privatelink-dns-zone-group-${each.value.ip_configuration.subresource_name}"
    private_dns_zone_ids = each.value.private_dns_zone_group.private_dns_zone_ids
  }

  lifecycle {
    ignore_changes = [tags, ]
  }
}

resource "azurerm_role_assignment" "rbac_roles" {
  scope                            = azurerm_storage_account.synapse_storage.id
  role_definition_name             = "Storage Blob Data Contributor"
  principal_id                     = data.azurerm_client_config.current.object_id
  skip_service_principal_aad_check = false

  lifecycle {
    ignore_changes = [ principal_id ]
  }
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "ping -c 21 localhost > /dev/null"
  }
  depends_on = [azurerm_role_assignment.rbac_roles]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "synapse_storage" {
  name               = "dataroot"
  storage_account_id = azurerm_storage_account.synapse_storage.id

  depends_on = [null_resource.delay]
}

resource "azurerm_storage_container" "container" {
  for_each = var.containers_details != null ? var.containers_details : {}

  name                  = each.key
  storage_account_name  = azurerm_storage_account.synapse_storage.name
  container_access_type = each.value.container_access_type

  depends_on = [
    azurerm_storage_data_lake_gen2_filesystem.synapse_storage, null_resource.delay
  ]
}

module "diagnostic_management_sa" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"

  resource_type = "Microsoft.Storage/storageAccounts"
  target_id     = azurerm_storage_account.synapse_storage.id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}

module "diagnostic_management_blob" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"

  resource_type = "Microsoft.Storage/storageAccounts/blobServices"
  target_id     = "${azurerm_storage_account.synapse_storage.id}/blobServices/default/"
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}

