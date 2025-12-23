variable "synapse_workspace_id" {
  type = string
}

variable "primary_blob_endpoint" {
  type = string
}

variable "disabled_alerts" {
  type = list(string)
}

variable "container_name" {
  type = string
}

variable "emails" {
  type = list(string)
}

# variable "storage_container_paths" {
#   description = "List of storage container paths"
#   type = list(string)
# }
