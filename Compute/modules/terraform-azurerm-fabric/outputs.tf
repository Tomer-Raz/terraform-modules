output "id" {
  value       = length(azurerm_fabric_capacity.fab_capacity) > 0 ? azurerm_fabric_capacity.fab_capacity[element(keys(azurerm_fabric_capacity.fab_capacity), 0)].id : ""
  description = "Resource identifier of the instance of Fabric Capacity."
}