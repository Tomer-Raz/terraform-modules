output "service_plan_ids" {
  value = { for e, plan in azurerm_service_plan.plan : e => plan.id }
}