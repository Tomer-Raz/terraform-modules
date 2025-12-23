locals {
  diagnostics_group = {
    for item in flatten([
      for resource_type, settings in jsondecode(file("${path.module}/config/diagnostic_mapping.json")) : [
        for category, items in settings : [
          for name, destinations in items : [
            for destination in destinations : {
              resource_type = resource_type
              category      = category
              name          = name
              destination   = destination
            }
          ]
        ]
      ]
    ]) : item.destination => item...
  }
}