variable "private_dns_zones" {
  type = object({
    common = object({
      resource_group_name = string
    })
    zones = map(string)
  })
}