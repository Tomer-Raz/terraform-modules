resource "azurerm_eventhub_authorization_rule" "example" {
for_each = var.eventhub_authorization_rule

  name                = each.value.name
  namespace_name      = each.value.namespace_name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = each.value.resource_group_name
  listen              = each.value.listen 
  send                = each.value.send
  manage              = each.value.manage
}