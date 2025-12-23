variable "name" {
  type = string
}

variable "display_name" {
  type = string
}

variable "policy_definition_id" {
  type = string
}

variable "scope" {
  type = string
}

variable "message" {
  type = any
}

variable "not_scopes" {
  type = list(string)
}

variable "parameters" {
  type = any
}

variable "location" {
  type = string
}

variable "description" {
  type = string
}