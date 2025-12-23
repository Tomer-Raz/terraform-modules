output "load_balancers" {
    description = "The load balancers configuration"
    value = {
        for load_balancer_key, load_balancer_value in azurerm_lb.load_balancer : load_balancer_key => {
            id = load_balancer_value.id
            private_ip_address = load_balancer_value.private_ip_address
            private_ip_addresses = load_balancer_value.private_ip_addresses
        }
    }
}

output "lb_backend_address_pool" {
    description = "The lb backend address pool configuration"
    value = {
        for lb_backend_address_pool_key, lb_backend_address_pool_value in azurerm_lb_backend_address_pool.lb_backend_address_pool : lb_backend_address_pool_key => {
            id = lb_backend_address_pool_value.id
            backend_ip_configurations = lb_backend_address_pool_value.backend_ip_configurations
            load_balancing_rules = lb_backend_address_pool_value.load_balancing_rules
            inbound_nat_rules = lb_backend_address_pool_value.inbound_nat_rules
            outbound_rules = lb_backend_address_pool_value.outbound_rules
        } 
    }
}

output "lb_backend_address_pool_address" {
    description = "The lb backend address pool address configuration"
    value = {
        for lb_backend_address_pool_address_key, lb_backend_address_pool_address_value in azurerm_lb_backend_address_pool_address.lb_backend_address_pool_address : lb_backend_address_pool_address_key => {
            id = lb_backend_address_pool_address_value.id
            # inbound_nat_rule_name = lb_backend_address_pool_address_value.inbound_nat_rule_name
            # frontend_port = lb_backend_address_pool_address_value.frontend_port
            # backend_port = lb_backend_address_pool_address_value.backend_port
        } 
    }
}

output "lb_probe" {
    description = "The lb prob configuration"
    value = {
        for lb_probe_key, lb_probe_value in azurerm_lb_probe.lb_probe : lb_probe_key => {
            id = lb_probe_value.id
        } 
    }
}




