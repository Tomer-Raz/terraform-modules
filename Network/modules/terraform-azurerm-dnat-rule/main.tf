data "local_file" "dnat_group_config" {
  filename = "${var.json_dnat_policy_config_path}/dnat_group_config.json"
}

data "local_file" "dnat_rule_collections" {
  for_each = fileset(var.json_dnat_policy_config_path, "dnat_collections/*.json")
  filename = "${var.json_dnat_policy_config_path}/${each.value}"
}

locals {
  group_config = jsondecode(data.local_file.dnat_group_config.content)
  dnat_rule_collections = [
    for file in data.local_file.dnat_rule_collections : jsondecode(file.content)
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_nat_azure_allow_origins_dnat" {
  name               = local.group_config.name
  firewall_policy_id = var.firewall_policy_id
  priority           = local.group_config.priority

  dynamic "nat_rule_collection" {
    for_each = local.dnat_rule_collections
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = "Dnat"

      dynamic "rule" {
        for_each = nat_rule_collection.value.dnat_rules
        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          destination_ports     = rule.value.destination_ports
          destination_address   = rule.value.destination_address
          translated_address    = rule.value.translated_address
          translated_port       = rule.value.translated_port
          protocols             = rule.value.protocols
        }
      }
    }
  }
}