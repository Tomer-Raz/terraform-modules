data "local_file" "app_group_config" {
  filename = "${var.json_app_policy_config_path}/app_group_config.json"
}

data "local_file" "app_rule_collections" {
  for_each = fileset(var.json_app_policy_config_path, "app_collections/*.json")
  filename = "${var.json_app_policy_config_path}/${each.value}"
}

locals {
  group_config = jsondecode(data.local_file.app_group_config.content)
  app_rule_collections = [
    for file in data.local_file.app_rule_collections : jsondecode(file.content)
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_app_azure_hub_spoke" {
  name               = local.group_config.name
  firewall_policy_id = var.firewall_policy_id
  priority           = local.group_config.priority
  provider           = azurerm.spoke

  dynamic "application_rule_collection" {
    for_each = local.app_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.app_rules
        content {
          name = rule.value.name
          source_addresses = rule.value.source_addresses
          source_ip_groups = rule.value.source_ip_groups
          destination_fqdns = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}