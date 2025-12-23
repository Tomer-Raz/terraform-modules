variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "acs_name" {
  type        = string
  description = "ACS instance name"
}

variable "eventgrid_namespace_id" {
  type        = string
  description = "EventGrid namespace ID"
}

variable "topic_name" {
  type        = string
  description = "EventGrid topic name"
}

variable "subscriptions" {
  type = map(object({
    event_settings = object({
      eventDeliverySchema = string
      endpointType        = string
      includedEventTypes  = list(string)
      advancedFilters = list(object({
        operatorType = string
        key          = string
        values       = list(string)
      }))
    })
    webhook_config = object({
      endpoint_url    = string
      entra_tenant_id = string
      entra_app_id    = string
    })
  }))
}
