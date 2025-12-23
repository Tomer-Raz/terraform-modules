# ./modules/Network/variables.tf

variable "load_balancers_details" {
  type = any
}

variable "firewall_app_rule_config" {
  description = "Configuration for firewall application rules"
  type        = any
}

variable "firewall_dnat_rule_config" {
  description = "Configuration for firewall DNAT rules"
  type        = any
}

variable "firewall_network_rule_config" {
  description = "Configuration for firewall network rules"
  type        = any
}

variable "firewall_policy_id" {
  description = "ID of the firewall policy"
  type        = string
}

variable "hub" {
  description = "Configuration for the hub"
  type        = any
}

variable "name_convention" {
  description = "Naming convention object"
  type        = any
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "load_balancers" {
  description = "Configuration for load balancers"
  type        = any
}

variable "lb_backend_address_pool" {
  description = "Configuration for load balancer backend address pools"
  type        = any
}

variable "lb_backend_address_pool_address" {
  description = "Configuration for load balancer backend address pool addresses"
  type        = any
}

variable "lb_probe" {
  description = "Configuration for load balancer probes"
  type        = any
}

variable "private_endpoints_list" {
  description = "List of private endpoints to create"
  type        = any
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "private_dns_zone" {
  description = "Configuration for private DNS zone"
  type        = any
}

variable "route_table" {
  description = "Configuration for route table"
  type        = any
}

variable "subnets" {
  description = "Configuration for subnets"
  type        = any
}

variable "resource_group" {
  description = "Name of the resource group for VNets"
  type        = string
}

variable "vnets" {
  description = "Configuration for virtual networks"
  type        = any
}

variable "shared_key" {
  type = string
}


variable "tags" {

}

