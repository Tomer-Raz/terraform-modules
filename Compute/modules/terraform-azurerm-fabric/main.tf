resource "azurerm_fabric_capacity" "fab_capacity" {
  for_each                  = var.config
  name                      = "${local.name_prefix}${each.key}sf"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  
  sku {
    name = each.value.sku
    tier = "Fabric"
  }

  administration_members = each.value.admin_emails
  
  tags = each.value.tags
}