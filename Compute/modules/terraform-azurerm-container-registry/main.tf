resource "azurerm_container_registry" "acr" {
  name                = "${local.name_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                = try(var.sku, "Basic")
  admin_enabled      = try(var.admin_enabled, false)
  
  identity {
    type = try(var.identity_type, "SystemAssigned")
  }

  dynamic "georeplications" {
    for_each = try(var.georeplications, {})
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = try(georeplications.value.zone_redundancy_enabled, false)
      tags                    = try(georeplications.value.tags, {})
    }
  }

  tags = var.tags
}

output "registry_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "registry_login_server" {
  description = "The login server URL for the Container Registry"
  value       = azurerm_container_registry.acr.login_server
}