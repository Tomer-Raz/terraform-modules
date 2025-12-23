data "azurerm_client_config" "current" {}

resource "azapi_resource" "topic" {
  type                      = "Microsoft.EventGrid/namespaces/topics@2023-12-15-preview"
  name                      = var.topic_name
  parent_id                 = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.EventGrid/namespaces/${var.namespace_name}"
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      publisherType = "Custom"
      description   = "Topic for ACS Chat Events"
    }
  })
}