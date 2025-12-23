# # Create the Stream Analytics clusters
resource "azapi_resource" "cluster" {

  for_each = var.clusters
  type     = "Microsoft.StreamAnalytics/clusters@2020-03-01"
  name     = "${local.name_prefix}-${each.key}-asa"
  location = each.value.location
  parent_id =each.value.parent_id

  body = jsonencode({
    properties = {}
    sku = {
      name = "DefaultV2"
      capacity =  each.value.cluster_capacity
    }

  })

  timeouts {
    create = "75m"
  }
}





# Create the Stream Analytics jobs
resource "azurerm_stream_analytics_job" "job" {
  for_each = var.jobs

  name                        = "${local.name_prefix}-${each.key}-asa-job"
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  streaming_units             = each.value.streaming_units
  transformation_query        = tostring(var.queries[each.key].query) #
  stream_analytics_cluster_id = azapi_resource.cluster[each.value.cluster_name].id
  sku_name                    ="StandardV2"

  identity {
    type = "SystemAssigned"

  }
}



# Create Event Hub inputs for the Stream Analytics job
resource "azurerm_stream_analytics_stream_input_eventhub" "input_eventhub" {
  for_each = { for key, input in var.inputs : key => input if input.type == "eventhub" }

  name                         = "${local.name_prefix}-${each.key}-asa-input"
  stream_analytics_job_name    = azurerm_stream_analytics_job.job[each.value.job_name].name
  resource_group_name          = azurerm_stream_analytics_job.job[each.value.job_name].resource_group_name
  eventhub_name                = each.value.eventhub_name
  servicebus_namespace         = each.value.servicebus_namespace
  eventhub_consumer_group_name = each.value.consumer_group_name
  authentication_mode          = "Msi"

  serialization {
    type     = "Json"
    encoding = "UTF8"
  }
}

# Create Blob inputs for the Stream Analytics job
resource "azurerm_stream_analytics_stream_input_blob" "input_blob" {
  for_each = { for key, input in var.inputs : key => input if input.type == "blob" }

  name                      = "${local.name_prefix}-${each.key}-asa-input"
  stream_analytics_job_name = azurerm_stream_analytics_job.job[each.value.job_name].name
  resource_group_name       = azurerm_stream_analytics_job.job[each.value.job_name].resource_group_name
  storage_account_name      = each.value.storage_account_name
  storage_container_name    = each.value.storage_container_name
  path_pattern              = each.value.path_pattern
  storage_account_key       = each.value.storage_account_key
  date_format               = each.value.date_format
  time_format               = each.value.time_format

  serialization {
    type     = "Json"
    encoding = "UTF8"
  }
}

# Create Blob outputs for the Stream Analytics job
resource "azurerm_stream_analytics_output_blob" "output_blob" {
  for_each = { for key, output in var.outputs : key => output if output.type == "blob" }

  name                      = "${local.name_prefix}-${each.key}-asa-output"
  stream_analytics_job_name = azurerm_stream_analytics_job.job[each.value.job_name].name
  resource_group_name       = azurerm_stream_analytics_job.job[each.value.job_name].resource_group_name
  storage_account_name      = each.value.storage_account_name
  storage_container_name    = each.value.storage_container_name
  path_pattern              = each.value.path_pattern
  date_format               = each.value.date_format
  time_format               = each.value.time_format
  authentication_mode       = "Msi"
  batch_min_rows            = each.value.batch_min_rows 
  batch_max_wait_time       = each.value.batch_max_wait_time 

  serialization {
    type     = "Parquet"

   
   
  }
}

# Create Event Hub outputs for the Stream Analytics job
resource "azurerm_stream_analytics_output_eventhub" "output_eventhub" {
  for_each = { for key, output in var.outputs : key => output if output.type == "eventhub" }

  name                      = "${local.name_prefix}-${each.key}-asa-output"
  stream_analytics_job_name = azurerm_stream_analytics_job.job[each.value.job_name].name
  resource_group_name       = azurerm_stream_analytics_job.job[each.value.job_name].resource_group_name
  eventhub_name             = each.value.eventhub_name
  servicebus_namespace      = each.value.servicebus_namespace
  authentication_mode       = "Msi"

  serialization {
    type     = "Json"
    format   = "LineSeparated"
    encoding = "UTF8"
  }
}

# Optionally create the managed private endpoints
resource "azurerm_stream_analytics_managed_private_endpoint" "managed_private_endpoint" {
  for_each = var.private_endpoints != {} ? var.private_endpoints : {}

  name                          = each.key
  resource_group_name           = each.value.resource_group_name
  stream_analytics_cluster_name = azapi_resource.cluster[each.value.cluster_name].name
  target_resource_id            = each.value.target_resource_id
  subresource_name              = each.value.subresource_name
}

# Create the diagnostic settings for the Stream Analytics jobs
module "diagnostic_management" {
  source  = "source/modules/azurerm//modules/Foundation/modules/terraform-azurerm-diagnostic-management"
  version = "1.0.289"

  for_each        = var.jobs
  resource_type   = "microsoft.streamanalytics/streamingjobs"
  target_id       = azurerm_stream_analytics_job.job[each.key].id
  secmon_law_id   = var.secmon_law_id
  opsmon_law_id   = var.opsmon_law_id
  name_convention = var.name_convention
}
