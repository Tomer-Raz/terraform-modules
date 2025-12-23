variable "private_dns_zones_links" {
  type = object({
    common = object({
      resource_group_name = string
    })
    links = map(list(string))
  })
}