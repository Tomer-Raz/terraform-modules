variable "groups" {
  type = map(object({
    name = string
    cmdb                      = string
    role_name                 = string
  }))
}
