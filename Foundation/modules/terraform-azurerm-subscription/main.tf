data "azurerm_billing_enrollment_account_scope" "bill_scope" {
  billing_account_name    = var.subscription_details.billing_account_name
  enrollment_account_name = var.subscription_details.enrollment_account_name
}

resource "azurerm_subscription" "subscriptions" {
  subscription_name = "${local.name_prefix}-${var.subscription_details.name}-sb"
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.bill_scope.id

  tags = var.tags
}

resource "azurerm_management_group_subscription_association" "subscription_association" {
  management_group_id = var.subscription_details.mgmt_id
  subscription_id = "/subscriptions/${azurerm_subscription.subscriptions.subscription_id}"
}

module "diagnostic_management_subscription" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.191"

  resource_type = "Microsoft.Resources/subscriptions"
  target_id     = "/subscriptions/${azurerm_subscription.subscriptions.subscription_id}"
  secmon_law_id = var.secmon_law_id
  opsmon_law_id = var.opsmon_law_id

  name_convention = var.name_convention
}
