data "azurerm_resource_group" "rg" {
  name = var.bigip_details.resource_group_name
}

resource "azurerm_user_assigned_identity" "user_identity" {
  count               = var.bigip_details.user_identity == null ? 1 : 0
  name                = format("%s-ident", local.instance_prefix)
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags = merge(local.tags,
    {
      Name = format("%s-ident", local.instance_prefix)
    }
  )
}

resource "random_id" "module_id" {
  byte_length = 2
}

resource "random_string" "password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}
