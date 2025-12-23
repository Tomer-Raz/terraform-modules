variable "clusters" {
  description = "Map of Stream Analytics cluster configurations."
  type = map(object({
    location            = string
    resource_group_name = string
    cluster_capacity    = number
    parent_id           = string
  }))
}

variable "jobs" {
  description = "Map of Stream Analytics job configurations."
  type = map(object({
    location             = string
    resource_group_name  = string
    streaming_units      = number
    #transformation_query = string
    cluster_name         = string
    storage_account_name = optional(string)
  }))
}

variable "queries" {
  type = map(object({ query = string }))

}

variable "inputs" {
  description = "Map of input configurations."
  type = map(object({
    type                   = string
    eventhub_name          = optional(string)
    servicebus_namespace   = optional(string)
    consumer_group_name    = optional(string)
    storage_account_name   = optional(string)
    storage_container_name = optional(string)
    path_pattern           = optional(string)
    date_format            = optional(string)
    time_format            = optional(string)
    job_name               = string
  }))
}

variable "outputs" {
  description = "Map of output configurations."
  type = map(object({
    type                   = string
    eventhub_name          = optional(string)
    servicebus_namespace   = optional(string)
    storage_account_name   = optional(string)
    storage_container_name = optional(string)
    path_pattern           = optional(string)
    date_format            = optional(string)
    time_format            = optional(string)
    job_name               = string
    batch_min_rows            = optional(string)
    batch_max_wait_time       = optional(string)
  }))
}

variable "name_convention" {
  description = "Naming convention details."
  type = object({
    region                    = string
    name = string
    env                       = string
    cmdb_infra                = string
    cmdb_project              = string
  })
}

variable "private_endpoints" {
  description = "Map of managed private endpoint configurations."
  type = map(object({
    job_name            = optional(string)
    cluster_name        = optional(string)
    resource_group_name = optional(string)
    subresource_name    = optional(string)
    target_resource_id  = optional(string)
  }))
  default = {}
}

variable "secmon_law_id" {
  description = "The ID of the Security Monitoring Law."
  type = string
}

variable "opsmon_law_id" {
  description = "The ID of the Operations Monitoring Law."
  type = string
}