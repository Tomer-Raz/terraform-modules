data "local_file" "network_group_config" {
  filename = "${var.json_network_policy_config_path}/network_group_config.json"
}

data "local_file" "network_rule_collections" {
  for_each = fileset(var.json_network_policy_config_path, "network_collections/*.json")
  filename = "${var.json_network_policy_config_path}/${each.value}"
}

locals {
  group_config = jsondecode(data.local_file.network_group_config.content)
  network_rule_collections = [
    for file in data.local_file.network_rule_collections : jsondecode(file.content)
  ]
}


resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_network_azure_hub_spoke" {
  name               = local.group_config.name
  firewall_policy_id = var.firewall_policy_id
  priority           = local.group_config.priority
  provider           = azurerm.spoke

  dynamic "network_rule_collection" {
    for_each = local.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.network_rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = rule.value.destination_ip_groups
          destination_fqdns     = rule.value.destination_fqdns
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }
}