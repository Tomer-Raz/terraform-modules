data "azurerm_client_config" "current" {}

resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "${local.name_prefix}-${var.synapse_name}-synw"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.datalake_id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "lXKcE3dNfp7xOLrHaceWJ"
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = true
  azuread_authentication_only          = true

  customer_managed_key {
    key_versionless_id = var.kv_key_versionless_id
    key_name           = var.key_name
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, sql_administrator_login_password]
  }
}

resource "azurerm_key_vault_access_policy" "workspace_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_synapse_workspace.synapse.identity[0].tenant_id
  object_id    = azurerm_synapse_workspace.synapse.identity[0].principal_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = local.all_key_permissions
  secret_permissions      = local.all_secret_permissions
  storage_permissions     = local.all_storage_permissions
  certificate_permissions = local.all_certificate_permissions
}

resource "azurerm_synapse_workspace_key" "synapse_key" {
  customer_managed_key_versionless_id = var.kv_key_versionless_id
  synapse_workspace_id                = azurerm_synapse_workspace.synapse.id
  active                              = true
  customer_managed_key_name           = var.key_name

  depends_on = [azurerm_key_vault_access_policy.workspace_policy]
}

resource "azurerm_synapse_workspace_aad_admin" "synapse_admins" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  login                = var.login_group_name
  object_id            = var.aad_admin_object_id
  tenant_id            = data.azurerm_client_config.current.tenant_id

  lifecycle {
    ignore_changes = [tenant_id]
  }

  depends_on = [azurerm_synapse_workspace_key.synapse_key]
}

resource "azurerm_synapse_firewall_rule" "AllowAzureServices" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

resource "azurerm_synapse_private_link_hub" "hub" {
  name                = "${local.prvlnk_name_prefix}prvlnkpl"
  resource_group_name = var.resource_group_name
  location            = var.location

  lifecycle {
    ignore_changes = [tags, ]
  }

  depends_on = [azurerm_synapse_workspace_aad_admin.synapse_admins]
}

resource "azurerm_private_endpoint" "synapse_private_endpoint" {
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
    private_connection_resource_id = azurerm_synapse_workspace.synapse.id
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

resource "azurerm_private_endpoint" "prvlnkhub_private_endpoint" {
  for_each = var.prvtlnk_pe_details != null ? var.prvtlnk_pe_details : {}

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
    private_connection_resource_id = azurerm_synapse_private_link_hub.hub.id
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
  scope                            = var.targetScope
  role_definition_name             = "storage blob data contributor"
  principal_id                     = azurerm_synapse_workspace.synapse.identity[0].principal_id
  skip_service_principal_aad_check = false
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "ping -c 21 localhost > /dev/null"
  }
  depends_on = [azurerm_role_assignment.rbac_roles]
}

resource "azurerm_synapse_managed_private_endpoint" "managedpe" {
  for_each = var.mng_pe_details != null ? var.mng_pe_details : {}

  name                 = each.key
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  target_resource_id   = var.target_resource_id
  subresource_name     = each.value.subresource_name

  depends_on = [null_resource.delay, azurerm_synapse_workspace_key.synapse_key]
}

resource "azurerm_synapse_spark_pool" "synapse" {
  count                = 1
  name                 = "${local.sparkpool_name_prefix}1"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 0
  spark_version        = "3.3"

  auto_scale {
    max_node_count = 10
    min_node_count = 5
  }
  auto_pause {
    delay_in_minutes = 5
  }
  library_requirement {
    content  = <<EOF
appnope==0.1.0
beautifulsoup4==4.6.3
EOF
    filename = "requirements.txt"
  }
  spark_config {
    content  = <<EOF
spark.shuffle.spill                true
EOF
    filename = "config.txt"
  }
  tags = {
    ENV = var.env
  }

  lifecycle {
    ignore_changes = [tags, spark_config]
  }
  depends_on = [azurerm_synapse_workspace_key.synapse_key, azurerm_synapse_workspace.synapse]
}

resource "azurerm_synapse_spark_pool" "synapse_v34" {
  count                = var.create_additional_spark_pool ? 1 : 0
  name                 = "${local.sparkpool_name_prefix}2"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 0
  spark_version        = "3.4"

  auto_scale {
    max_node_count = 10
    min_node_count = 5
  }
  auto_pause {
    delay_in_minutes = 5
  }
  library_requirement {
    content  = <<EOF
appnope==0.1.0
beautifulsoup4==4.6.3
EOF
    filename = "requirements.txt"
  }
  spark_config {
    content  = <<EOF
spark.shuffle.spill                true
EOF
    filename = "config.txt"
  }
  tags = {
    ENV = var.env
  }

  lifecycle {
    ignore_changes = [tags, spark_config]
  }
  depends_on = [azurerm_synapse_workspace_key.synapse_key, azurerm_synapse_workspace.synapse]
}


resource "azurerm_synapse_role_assignment" "synapse_studio_rbac" {
  for_each = var.synapse_rbac_details != null ? var.synapse_rbac_details : {}

  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  role_name            = each.value.role_name
  principal_id         = each.value.principal_id

  depends_on = [azurerm_synapse_managed_private_endpoint.managedpe]
}

module "diagnostic_management_synapse_workspace" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.255"

  resource_type = "Microsoft.Synapse/workspaces"
  target_id     = azurerm_synapse_workspace.synapse.id
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention

  depends_on = [azurerm_synapse_workspace.synapse]
}

module "diagnostic_management_apache_spark_pool" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.255"

  resource_type = "Microsoft.Synapse/workspaces/bigDataPools"
  target_id     = "${azurerm_synapse_workspace.synapse.id}/bigDataPools/${local.sparkpool_name_prefix}1/"
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention

  depends_on = [azurerm_synapse_workspace.synapse, azurerm_synapse_spark_pool.synapse]
}

module "diagnostic_management_apache_spark_pool_v34" {
  count   = var.create_additional_spark_pool ? 1 : 0
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.255"

  resource_type = "Microsoft.Synapse/workspaces/bigDataPools"
  target_id     = "${azurerm_synapse_workspace.synapse.id}/bigDataPools/${local.sparkpool_name_prefix}2/"
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention

  depends_on = [azurerm_synapse_workspace.synapse, azurerm_synapse_spark_pool.synapse_v34]
}
