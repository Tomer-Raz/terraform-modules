locals {
  naming_prefix = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-${var.name_convention.cmdb_infra}-${var.name_convention.cmdb_project}"
  bigip_map = {
    "mgmt_subnet_ids"            = var.bigip_details.network.subnets.mgmt_subnet_ids
    "external_subnet_ids"        = var.bigip_details.network.subnets.external_subnet_ids
    "internal_subnet_ids"        = var.bigip_details.network.subnets.internal_subnet_ids
  }

  mgmt_private_subnet_id = [
    for subnet in local.bigip_map["mgmt_subnet_ids"] :
    subnet["subnet_id"]
    if subnet["public_ip"] == false
  ]
  mgmt_private_ip_primary = [
    for private in local.bigip_map["mgmt_subnet_ids"] :
    private["private_ip_primary"]
    if private["public_ip"] == false && private["private_ip_primary"] != ""
  ]
  mgmt_private_index = [
    for index, subnet in local.bigip_map["mgmt_subnet_ids"] :
    index
    if subnet["public_ip"] == false
  ]

  external_private_subnet_id = [
    for subnet in local.bigip_map["external_subnet_ids"] :
    subnet["subnet_id"]
    if subnet["public_ip"] == false
  ]
  external_private_ip_primary = [
    for private in local.bigip_map["external_subnet_ids"] :
    private["private_ip_primary"]
    if private["public_ip"] == false
  ]
  external_private_ip_secondary = [
    for private in local.bigip_map["external_subnet_ids"] :
    private["private_ip_secondary"]
    if private["public_ip"] == false
  ]
  external_private_index = [
    for index, subnet in local.bigip_map["external_subnet_ids"] :
    index
    if subnet["public_ip"] == false
  ]

  internal_private_subnet_id = [
    for subnet in local.bigip_map["internal_subnet_ids"] :
    subnet["subnet_id"]
    if subnet["public_ip"] == false
  ]
  internal_private_index = [
    for index, subnet in local.bigip_map["internal_subnet_ids"] :
    index
    if subnet["public_ip"] == false
  ]
  internal_private_ip_primary = [
    for private in local.bigip_map["internal_subnet_ids"] :
    private["private_ip_primary"]
    if private["public_ip"] == false
  ]


  total_nics      = length(concat(local.mgmt_private_subnet_id, local.external_private_subnet_id, local.internal_private_subnet_id))
  vlan_list       = concat(local.external_private_subnet_id, local.internal_private_subnet_id)
  selfip_list     = concat(azurerm_network_interface.external_nic.*.private_ip_address, azurerm_network_interface.internal_nic.*.private_ip_address)
  instance_prefix = format("%s-%s", local.naming_prefix, random_id.module_id.hex)
  gw_bytes_nic    = local.total_nics > 1 ? element(split("/", local.selfip_list[0]), 0) : ""

  # clustermemberDO1 = local.total_nics == 1 ? templatefile("${path.module}/templates/onboard_do_1nic.tpl", {
  #   hostname      = azurerm_network_interface.mgmt_nic[0].private_ip_address
  #   name_servers  = join(",", formatlist("\"%s\"", ["169.254.169.253"]))
  #   search_domain = "f5.com"
  #   ntp_servers   = join(",", formatlist("\"%s\"", ["169.254.169.123"]))
  # }) : ""

  # clustermemberDO2 = local.total_nics == 2 ? templatefile("${path.module}/templates/onboard_do_2nic.tpl", {
  #   hostname      = azurerm_network_interface.mgmt_nic[0].private_ip_address
  #   name_servers  = join(",", formatlist("\"%s\"", ["169.254.169.253"]))
  #   search_domain = "f5.com"
  #   ntp_servers   = join(",", formatlist("\"%s\"", ["169.254.169.123"]))
  #   vlan-name     = element(split("/", local.vlan_list[0]), length(split("/", local.vlan_list[0])) - 1)
  #   self-ip       = local.selfip_list[0]
  #   gateway       = join(".", concat(slice(split(".", local.gw_bytes_nic), 0, 3), [1]))
  # }) : ""

  # clustermemberDO3 = local.total_nics >= 3 ? templatefile("${path.module}/templates/onboard_do_3nic.tpl", {
  #   hostname      = azurerm_network_interface.mgmt_nic[0].private_ip_address
  #   name_servers  = join(",", formatlist("\"%s\"", ["169.254.169.253"]))
  #   search_domain = "f5.com"
  #   ntp_servers   = join(",", formatlist("\"%s\"", ["169.254.169.123"]))
  #   vlan-name1    = element(split("/", local.vlan_list[0]), length(split("/", local.vlan_list[0])) - 1)
  #   self-ip1      = local.selfip_list[0]
  #   vlan-name2    = element(split("/", local.vlan_list[1]), length(split("/", local.vlan_list[1])) - 1)
  #   self-ip2      = local.selfip_list[1]
  #   gateway       = join(".", concat(slice(split(".", local.gw_bytes_nic), 0, 3), [1]))
  # }) : ""

  tags = merge(
    var.tags,
    {
      Prefix = format("%s", local.instance_prefix)
      source = "terraform"
    }
  )
}
