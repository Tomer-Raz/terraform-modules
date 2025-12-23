variable "table_retention" {
  type = map(object({
    retention_in_days       = optional(number)
    total_retention_in_days = optional(number)
    plan                    = optional(string)
  }))
  default = {}
}

variable "workspace_id" {
  type = string
}
