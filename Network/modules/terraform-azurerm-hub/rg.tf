resource "azurerm_resource_group" "hub_rg" {
  name     = "${local.naming_prefix}-hub-rg"
  location = var.hub.location

  lifecycle {
    ignore_changes = [
     tags
    ]
  }
}



