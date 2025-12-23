variable "storage_account_name" {
  description = "The name of the Storage Account where the containers will be created"
  type        = string
}

variable "containers" {
  description = "Map of container configurations"
  type = map(object({
    access_type = string
  }))
}
