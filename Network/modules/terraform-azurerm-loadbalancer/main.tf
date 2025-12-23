locals {
  name_prefix                     = "${var.name_convention.region}-${var.name_convention.name}${var.name_convention.env}-${var.name_convention.cmdb_infra}-${var.name_convention.cmdb_project}"
  load_balancers                  = var.load_balancers_details.load_balancers
  lb_backend_address_pool         = var.load_balancers_details.lb_backend_address_pool
  lb_backend_address_pool_address = var.load_balancers_details.lb_backend_address_pool_address
  lb_probe                        = var.load_balancers_details.lb_probe
  lb_rules                        = var.load_balancers_details.lb_rules
}

resource "azurerm_lb" "load_balancer" {
  for_each            = { for key, lb in local.load_balancers : "${local.name_prefix}-${key}-lb" => lb }
  name                = each.key
  resource_group_name = var.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                          = "${each.value.frontend_ip_configuration_name}-lb-fe"
    subnet_id                     = each.value.subnet_id
    private_ip_address            = each.value.private_ip_address
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
  depends_on = [var.name_convention]
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  for_each        = { for key, lbap in local.lb_backend_address_pool : "${local.name_prefix}-${lbap.load_balancer_key_name}-lb-${key}-ap" => lbap }
  name            = each.key # "${local.name_prefix}-${each.value.load_balancer_key_name}-lb-${each.key}-ap"
  loadbalancer_id = azurerm_lb.load_balancer["${local.name_prefix}-${each.value.load_balancer_key_name}-lb"].id
  depends_on      = [azurerm_lb.load_balancer]
}

resource "azurerm_lb_backend_address_pool_address" "lb_backend_address_pool_address" {
  for_each                = { for key, lbapa in local.lb_backend_address_pool_address : "${local.name_prefix}-${lbapa.load_balancer_key_name}-lb-${key}-apa" => lbapa }
  name                    = each.key #"${local.name_prefix}-${each.value.load_balancer_key_name}-lb-apa-${each.key}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool["${local.name_prefix}-${each.value.load_balancer_key_name}-lb-${each.value.address_pool}-ap"].id
  virtual_network_id      = each.value.virtual_network_id
  ip_address              = each.value.ip_address
  depends_on              = [azurerm_lb_backend_address_pool.lb_backend_address_pool]
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each            = { for key, lbhp in local.lb_probe : "${local.name_prefix}-${lbhp.load_balancer_key_name}-lb-${key}-hp" => lbhp }
  name                = each.key # "${local.name_prefix}-${each.value.load_balancer_key_name}-lb-hp"
  loadbalancer_id     = azurerm_lb.load_balancer["${local.name_prefix}-${each.value.load_balancer_key_name}-lb"].id
  port                = each.value.port
  protocol            = each.value.protocol
  probe_threshold     = each.value.probe_threshold
  request_path        = each.value.request_path
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
  depends_on          = [azurerm_lb.load_balancer]
}


resource "azurerm_lb_rule" "lb_rule" {
  for_each                       = { for key, lbrule in local.lb_rules : "${local.name_prefix}-${lbrule.load_balancer_key_name}-lb-${key}-rule" => lbrule }
  name                           = each.key # "${local.name_prefix}-${each.value.rule_key}-rule"
  loadbalancer_id                = azurerm_lb.load_balancer["${local.name_prefix}-${each.value.load_balancer_key_name}-lb"].id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.load_balancer["${local.name_prefix}-${each.value.load_balancer_key_name}-lb"].frontend_ip_configuration[0].name
  enable_floating_ip             = each.value.enable_floating_ip
  backend_address_pool_ids       = [for pool_name in each.value.backend_address_pools : azurerm_lb_backend_address_pool.lb_backend_address_pool["${local.name_prefix}-${each.value.load_balancer_key_name}-lb-${pool_name}-ap"].id]
  idle_timeout_in_minutes        = 4
  probe_id                       = azurerm_lb_probe.lb_probe["${local.name_prefix}-${each.value.load_balancer_key_name}-lb-${each.value.prob_name}-hp"].id

  depends_on = [
    azurerm_lb.load_balancer,
    azurerm_lb_probe.lb_probe
  ]
}
