data "azurerm_client_config" "current" {}

resource "azapi_resource" "system_topic" {
  type                      = "Microsoft.EventGrid/systemTopics@2023-12-15-preview"
  name                      = "${var.acs_name}-system-topic"
  location                  = "global"
  parent_id                 = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  schema_validation_enabled = false

  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    properties = {
      source    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Communication/communicationServices/${var.acs_name}"
      topicType = "Microsoft.Communication.CommunicationServices"
    }
  })
}

# Create role assignment
resource "azurerm_role_assignment" "eventgrid_sender" {
  scope                = "${var.eventgrid_namespace_id}/topics/${var.topic_name}"
  role_definition_name = "EventGrid Data Sender"
  principal_id         = azapi_resource.system_topic.identity[0].principal_id
}

resource "azapi_resource" "event_subscription" {
  type                      = "Microsoft.EventGrid/systemTopics/eventSubscriptions@2023-12-15-preview"
  name                      = "forward-to-namespace"
  parent_id                 = azapi_resource.system_topic.id
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      eventDeliverySchema = "CloudEventSchemaV1_0",
      filter = {
        includedEventTypes = [
          "Microsoft.Communication.ChatMessageReceived"
        ]
      },
      deliveryWithResourceIdentity = {
        destination = {
          endpointType = "NamespaceTopic",
          properties = {
            resourceId = "${var.eventgrid_namespace_id}/topics/${var.topic_name}"
          }
        },
        identity = {
          type = "SystemAssigned"
        }
      }
    }
  })

  depends_on = [azurerm_role_assignment.eventgrid_sender]
}

resource "azapi_resource" "webhook_subscription" {
  for_each                  = var.subscriptions
  type                      = "Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15"
  name                      = "${each.key}-webhook-subscription"
  parent_id                 = azapi_resource.system_topic.id
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      eventDeliverySchema = each.value.event_settings.eventDeliverySchema
      destination = {
        endpointType = each.value.event_settings.endpointType
        properties = {
          endpointUrl                            = each.value.webhook_config.endpoint_url
          azureActiveDirectoryTenantId           = each.value.webhook_config.entra_tenant_id
          azureActiveDirectoryApplicationIdOrUri = each.value.webhook_config.entra_app_id
          maxEventsPerBatch                      = 1
          preferredBatchSizeInKilobytes          = 64
        }
      }
      filter = {
        enableAdvancedFilteringOnArrays = true
        includedEventTypes              = each.value.event_settings.includedEventTypes
        advancedFilters                 = each.value.event_settings.advancedFilters
      }
      retryPolicy = {
        maxDeliveryAttempts      = 30,
        eventTimeToLiveInMinutes = 1440
      }
    }
  })
}
