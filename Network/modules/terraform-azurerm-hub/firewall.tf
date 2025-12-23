resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-azfw-azfw-fw-policy"  
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  sku                 = "Premium"

  dns {
    proxy_enabled = "false"
    servers       = var.hub.dns_servers
  }

  tags = var.hub.fw_policy_tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

### Azure Firewall ###
resource "azurerm_firewall" "fw" {
  name                = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-azfw-azfw-fw"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnets["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.public_ips["fw_pip"].id
  }

   dynamic "ip_configuration" {
    for_each = local.additional_fw_pips
    content {
      name                 = "ip_configuration_${ip_configuration.key}"
      public_ip_address_id = azurerm_public_ip.public_ips[ip_configuration.key].id
    }
  }

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_subnet.subnets
  ]
  
  tags = var.hub.fw_tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "fw_diagnostic_settings" {
  name               = "${local.naming_prefix}-fw_diagnostic_settings"
  target_resource_id = azurerm_firewall.fw.id
  log_analytics_workspace_id = var.hub.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
      category = "AZFWApplicationRule"
  }
  
  enabled_log {
      category = "AZFWNetworkRule"

  }
  enabled_log {
      category = "AZFWNatRule"
  }
  
  metric {
    category = "AllMetrics"
  }
 }

