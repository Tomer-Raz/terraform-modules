resource "azurerm_container_app_environment" "acae" {
  name                = "${local.name_prefix}-cae"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  internal_load_balancer_enabled = var.lb_enabled
  infrastructure_subnet_id = var.subnet_id

}


output "environment_id" {
  value = azurerm_container_app_environment.acae.id
}