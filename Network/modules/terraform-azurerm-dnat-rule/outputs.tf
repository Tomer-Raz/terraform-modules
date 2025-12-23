# output "rule_collection_group_id" {
#   description = "The ID of the Firewall Policy Rule Collection Group"
#   value       = azurerm_firewall_policy_rule_collection_group.fw_policy_nat_azure_allow_origins_dnat.id
# }

# output "rule_collection_group_name" {
#   description = "The name of the Firewall Policy Rule Collection Group"
#   value       = azurerm_firewall_policy_rule_collection_group.fw_policy_nat_azure_allow_origins_dnat.name
# }

# output "firewall_policy_id" {
#   description = "The ID of the Firewall Policy associated with this Rule Collection Group"
#   value       = var.firewall_policy_id
# }

# output "group_config" {
#   description = "The decoded group configuration"
#   value       = local.group_config
# }

# output "dnat_rule_collections" {
#   description = "The decoded DNAT rule collections"
#   value       = local.dnat_rule_collections
# }

# output "dnat_rules" {
#   description = "All DNAT rules across all collections"
#   value = flatten([
#     for collection in local.dnat_rule_collections : [
#       for rule in collection.dnat_rules : {
#         collection_name       = collection.name
#         collection_priority   = collection.priority
#         rule_name             = rule.name
#         source_addresses      = rule.source_addresses
#         destination_ports     = rule.destination_ports
#         destination_address   = rule.destination_addresses
#         translated_address    = rule.translated_address
#         translated_port       = rule.translated_port
#         protocols             = rule.protocols
#       }
#     ]
#   ])
# }