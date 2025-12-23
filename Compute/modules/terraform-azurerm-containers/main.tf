resource "azurerm_storage_container" "containers" {
  for_each = var.containers

  name                  = each.key
  storage_account_name  = var.storage_account_name
  container_access_type = each.value.access_type
}