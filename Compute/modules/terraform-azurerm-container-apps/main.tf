resource "azurerm_container_app" "aca" {
  for_each = var.container_apps

  name                         = "${local.name_prefix}-${each.key}-aca"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.environment_id
  revision_mode                = "Single"
  workload_profile_name        = try(each.value.workload_profile_name, "Consumption")

  identity {
    type = try(each.value.identity_type, "None")
  }

  dynamic "registry" {
    for_each = try(each.value.registry, {})
    content {
      server                = registry.value.server
      username              = registry.value.username
      password_secret_name  = registry.value.password_secret_name
    }
  }

  template {
    container {
      name    = "${local.name_prefix}-${each.key}-aca"
      image   = each.value.image
      cpu     = each.value.cpu
      memory  = each.value.memory
      ephemeral_storage = try(each.value.ephemeral_storage, "2Gi")

      dynamic "env" {
        for_each = try(each.value.environment_variables, {})
        content {
          name  = env.key
          value = env.value
        }
      }
    }

    min_replicas    = try(each.value.replicas.min, 1)
    max_replicas    = try(each.value.replicas.max, 1)
    revision_suffix = try(each.value.revision_suffix, "")
  }

  dynamic "ingress" {
    for_each = each.value.ingress != null ? [each.value.ingress] : []
    content {
      allow_insecure_connections = try(ingress.value.allow_insecure, false)
      external_enabled          = try(ingress.value.external, false)
      target_port              = try(ingress.value.target_port, 80)
      transport                = try(ingress.value.transport, "auto")
      
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  tags = var.tags
}
