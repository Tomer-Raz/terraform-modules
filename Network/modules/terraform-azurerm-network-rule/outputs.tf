output "rule_collection_group_id" {
  description = "The ID of the Firewall Policy Rule Collection Group"
  value       = azurerm_firewall_policy_rule_collection_group.fw_policy_network_azure_hub_spoke.id
}

output "rule_collection_group_name" {
  description = "The name of the Firewall Policy Rule Collection Group"
  value       = azurerm_firewall_policy_rule_collection_group.fw_policy_network_azure_hub_spoke.name
}

output "firewall_policy_id" {
  description = "The ID of the Firewall Policy associated with this Rule Collection Group"
  value       = var.firewall_policy_id
}

output "group_config" {
  description = "The decoded group configuration"
  value       = local.group_config
}

output "network_rule_collections" {
  description = "The decoded network rule collections"
  value       = local.network_rule_collections
}

output "network_rules" {
  description = "All network rules across all collections"
  value = flatten([
    for collection in local.network_rule_collections : [
      for rule in collection.network_rules : {
        collection_name        = collection.name
        collection_priority    = collection.priority
        collection_action      = collection.action
        rule_name              = rule.name
        protocols              = rule.protocols
        source_addresses       = rule.source_addresses
        source_ip_groups       = rule.source_ip_groups
        destination_addresses  = rule.destination_addresses
        destination_ip_groups  = rule.destination_ip_groups
        destination_fqdns      = rule.destination_fqdns
        destination_ports      = rule.destination_ports
      }
    ]
  ])
}