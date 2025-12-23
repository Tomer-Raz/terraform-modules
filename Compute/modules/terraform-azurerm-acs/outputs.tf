output "acs_ids" {
  value = { for key, acs in azurerm_communication_service.acs : key => acs.id }
}

output "acs_names" {
  value = { for key, acs in azurerm_communication_service.acs : key => acs.name }
}

output "acs_endpoint" {
  value = {
    for k, v in azurerm_communication_service.acs : k => {
      data_location = v.data_location
    }
  }
}

output "acs_identities" {
  description = "The managed identities of the Communication Services"
  value = {
    for k, v in azapi_update_resource.acs_identity : k => {
      principal_id = try(jsondecode(v.output).identity.principalId, null)
      tenant_id    = try(jsondecode(v.output).identity.tenantId, null)
      type         = try(jsondecode(v.output).identity.type, null)
    }
  }
}