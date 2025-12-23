module "firewall_policy_app_rule" {
  source                      = "./modules/terraform-azurerm-app-rule"
  firewall_policy_id          = ""
  json_app_policy_config_path = ""
}

module "firewall_policy_dnat_rule" {
  source                       = "./modules/terraform-azurerm-dnat-rule"
  firewall_policy_id           = ""
  json_dnat_policy_config_path = ""
}

module "firewall_policy_network_rule" {
  source                          = "./modules/terraform-azurerm-network-rule"
  firewall_policy_id              = ""
  json_network_policy_config_path = ""
}

module "hub" {
  source     = "./modules/terraform-azurerm-hub"
  hub        = var.hub
  shared_key = var.shared_key
}

module "loadbalancer" {
  source                 = "./modules/terraform-azurerm-loadbalancer"
  load_balancers_details = var.load_balancers_details
  name_convention        = var.name_convention
  resource_group_name    = var.resource_group_name

}

module "private_endpoint" {
  source                 = "./modules/terraform-azurerm-private-endpoint"
  private_endpoints_list = var.private_endpoints_list
  location               = var.location
  private_dns_zones      = {}
  name_convention        = var.name_convention
}

module "subnet" {
  source              = "./modules/terraform-azurerm-subnet"
  name_convention     = var.name_convention
  resource_group_name = var.resource_group_name
  subnets             = var.subnets
}

module "vnet" {
  source              = "./modules/terraform-azurerm-vnet"
  name_convention     = var.name_convention
  resource_group_name = var.resource_group
  vnets               = var.vnets
}
