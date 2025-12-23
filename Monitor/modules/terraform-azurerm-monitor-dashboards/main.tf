data "local_file" "dashboard_files" {
  for_each = fileset("${var.dashboard_files_folder_path}", "*.json")
  filename = "${var.dashboard_files_folder_path}/${each.value}"
}

locals {
  files = {
    for key, value in data.local_file.dashboard_files :
    key => {
      name                = jsondecode(value.content)["name"]
      resource_group_name = var.dashboards.resource_group_name
      location            = var.dashboards.location
      properties          = jsondecode(value.content)["properties"]
    }
  }
}

resource "azurerm_portal_dashboard" "dashboard" {
  for_each             = local.files
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  dashboard_properties = jsonencode(each.value.properties)
}