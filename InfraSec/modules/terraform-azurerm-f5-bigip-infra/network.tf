# Deploy BIG-IP with N-Nic interface 
resource "azurerm_network_interface" "mgmt_nic" {
  count               = length(local.bigip_map["mgmt_subnet_ids"])
  name                = "${local.instance_prefix}-mgmt-nic-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "${local.instance_prefix}-mgmt-ip-${count.index}"
    subnet_id                     = local.bigip_map["mgmt_subnet_ids"][count.index]["subnet_id"]
    private_ip_address_allocation = (length(local.mgmt_private_ip_primary) > 0 ? "Static" : "Dynamic")
    private_ip_address            = (length(local.mgmt_private_ip_primary) > 0 ? local.mgmt_private_ip_primary[count.index] : null)
    public_ip_address_id          = null
  }
  tags = merge(local.tags, {
    Name = format("%s-mgmt-nic-%s", local.instance_prefix, count.index)
    }
  )
}

resource "azurerm_network_interface" "external_nic" {
  count                 = length(local.external_private_subnet_id)
  name                  = "${local.instance_prefix}-ext-nic-${count.index}"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = var.bigip_details.network.external_enable_ip_forwarding
  ip_configuration {
    name                          = "${local.instance_prefix}-ext-ip-${count.index}"
    subnet_id                     = local.external_private_subnet_id[count.index]
    primary                       = "true"
    private_ip_address_allocation = (length(local.external_private_ip_primary[count.index]) > 0 ? "Static" : "Dynamic")
    private_ip_address            = (length(local.external_private_ip_primary[count.index]) > 0 ? local.external_private_ip_primary[count.index] : null)
  }
  # ip_configuration {
  #   name                          = "${local.instance_prefix}-secondary-ext-ip-${count.index}"
  #   subnet_id                     = local.external_private_subnet_id[count.index]
  #   private_ip_address_allocation = (length(local.external_private_ip_secondary[count.index]) > 0 ? "Static" : "Dynamic")
  #   private_ip_address            = (length(local.external_private_ip_secondary[count.index]) > 0 ? local.external_private_ip_secondary[count.index] : null)
  # }
  tags = merge(local.tags, var.externalnic_failover_tags, {
    Name = format("%s-ext-nic-%s", local.instance_prefix, count.index),
    }
  )
}

resource "azurerm_network_interface" "internal_nic" {
  count               = length(local.internal_private_subnet_id)
  name                = "${local.instance_prefix}-int-nic-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = var.bigip_details.network.external_enable_ip_forwarding

  ip_configuration {
    name                          = "${local.instance_prefix}-int-ip-${count.index}"
    subnet_id                     = local.internal_private_subnet_id[count.index]
    private_ip_address_allocation = (length(local.internal_private_ip_primary[count.index]) > 0 ? "Static" : "Dynamic")
    private_ip_address            = (length(local.internal_private_ip_primary[count.index]) > 0 ? local.internal_private_ip_primary[count.index] : null)
  }
  tags = merge(local.tags, var.internalnic_failover_tags, {
    Name = format("%s-internal-nic-%s", local.instance_prefix, count.index)
    }
  )
}

# resource "azurerm_network_interface_security_group_association" "mgmt_security" {
#   count                     = length(local.bigip_map["mgmt_securitygroup_ids"])
#   network_interface_id      = azurerm_network_interface.mgmt_nic[count.index].id
#   network_security_group_id = local.bigip_map["mgmt_securitygroup_ids"][count.index]
# }

# resource "azurerm_network_interface_application_security_group_association" "mgmt_security" {
#   count                         = length(var.bigip_details.network.nsgs.mgmt_app_securitygroup_ids)
#   network_interface_id          = azurerm_network_interface.mgmt_nic[count.index].id
#   application_security_group_id = var.bigip_details.network.nsgs.mgmt_app_securitygroup_ids[count.index]
# }

# resource "azurerm_network_interface_security_group_association" "external_security" {
#   count                     = length(local.external_private_security_id)
#   network_interface_id      = azurerm_network_interface.external_nic[count.index].id
#   network_security_group_id = local.external_private_security_id[count.index]
# }

# resource "azurerm_network_interface_application_security_group_association" "external_security" {
#   count                         = length(var.bigip_details.network.nsgs.external_app_securitygroup_ids)
#   network_interface_id          = concat(azurerm_network_interface.external_nic.*.id, azurerm_network_interface.external_public_nic.*.id)[count.index]
#   application_security_group_id = var.bigip_details.network.nsgs.external_app_securitygroup_ids[count.index]
# }

# resource "azurerm_network_interface_security_group_association" "internal_security" {
#   count                     = length(local.internal_private_security_id)
#   network_interface_id      = azurerm_network_interface.internal_nic[count.index].id
#   network_security_group_id = local.internal_private_security_id[count.index]
# }
# resource "azurerm_network_interface_application_security_group_association" "internal_security" {
#   count                         = length(var.bigip_details.network.nsgs.internal_app_securitygroup_ids)
#   network_interface_id          = azurerm_network_interface.internal_nic[count.index].id
#   application_security_group_id = var.bigip_details.network.nsgs.internal_app_securitygroup_ids[count.index]
# }
