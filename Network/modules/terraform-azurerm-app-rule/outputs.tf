output "azurerm_firewall_policy_rule_collection_group_id" {
  description = "The ID of the Azure Firewall Policy Rule Collection Group for Application Rules."
  value       = azurerm_firewall_policy_rule_collection_group.fw_policy_app_azure_hub_spoke.id
}