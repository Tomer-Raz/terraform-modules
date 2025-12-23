module "built-in-pol" {
  source = "./modules/terraform-azurerm-built-in-pol"
}

module "built-in-pol-wth-params" {
  source = "./modules/terraform-azurerm-built-in-pol-with-params"
}

module "custom-pol-assign" {
  source = "./modules/terraform-azurerm-custom-pol-assign"
}

module "custom-pol-definition" {
  source = "./modules/terraform-azurerm-custom-pool-definition"
}
