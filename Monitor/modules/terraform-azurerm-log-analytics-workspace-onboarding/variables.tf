variable "workspace_onboarding" {
  type = map(object({
    workspace_id                  = string
    customer_managed_key_enabled  = bool
  }))
}