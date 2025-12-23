variable "eventhub_authorization_rule" {
  description = "venthub_authorization_rul"
  type = map(object({
    name                     = string
    namespace_name           = string
    eventhub_name            = string
    resource_group_name      = string
    listen                   = bool
    send                     = bool
    manage                   = bool
  }))
}

