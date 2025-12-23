# Stream Analytics Module

This Terraform module creates and manages Azure Stream Analytics resources, including clusters, jobs, inputs, outputs, and managed private endpoints.

## Usage

```terraform

data "tfe_outputs" monitor {
    organization = "<TFE organization>"
    workspace    = "<TFE monitor workspace>"
}

locals {
  config = jsondecode(file("./ccoe/stream-analytics.json"))
}

module "stream_analytics" {
  source                       = "./modules/stream_analytics"
  clusters                     = local.config.clusters
  jobs                         = local.config.jobs
  inputs                       = local.config.inputs
  outputs                      = local.config.outputs
  name_convention              = local.config.name_convention
  private_endpoints            = local.config.private_endpoints
  secmon_law_id                = data.tfe_outputs.monitor.values.log_analytics_workspace["secmon"].id 
  opsmon_law_id                = data.tfe_outputs.monitor.values.log_analytics_workspace["opsmon"].id
}
```

### Example JSON Configuration

Here is an example of the JSON configuration file (`stream-analytics.json`) that you can use to provide the necessary inputs to the module:

```json
{
  "clusters": {
    "crm": {
      "location": "westeurope",
      "resource_group_name": "crm-rt",
      "cluster_capacity": 36
    }
  },
  "jobs": {
    "crm_rt": {
      "location": "westeurope",
      "resource_group_name": "crm-rt",
      "streaming_units": 1,
      "transformation_query": "SELECT * INTO we-iydy-azus-opdx-blob-asa-output FROM we-iydy-azus-opdx-eventhub-asa-input",
      "cluster_name": "crm"
    }
  },
  "inputs": {
    "eventhub": {
      "type": "eventhub",
      "eventhub_name": "crm-rt-account",
      "servicebus_namespace": "crmrtevethub01evnt",
      "consumer_group_name": "crm-rt-account_crm-rt-account_consumer_group",
      "job_name": "crm_rt"
    }
  },
  "outputs": {
    "blob": {
      "type": "blob",
      "storage_account_name": "your-storage-account-name",
      "storage_container_name": "crm-account",
      "path_pattern": "{date}/{time}",
      "date_format": "yyyy/MM/dd",
      "time_format": "HH:mm:ss",
      "job_name": "crm_rt"
    }
  },
  "name_convention": {
    "region": "we",
    "name": "i",
    "env": "ydy",
    "cmdb_infra": "azus",
    "cmdb_project": "opdx"
  },
  "private_endpoints": {
    "eventhub_pe": {
      "job_name": "crm_rt",
      "cluster_name": "crm",
      "resource_group_name": "crm-rt",
      "subresource_name": "namespace",
      "target_resource_id": "/subscriptions/2990d030-62b0-4cfe-8a71-61ea0015bb8f/resourceGroups/crm-rt/providers/Microsoft.EventHub/namespaces/crmrtevethub01evnt"
    }
  }
}
```

### Steps to Use

1. **Create the JSON Configuration File**: Create a JSON configuration file (`stream-analytics.json`) with the necessary inputs as shown in the example above.

2. **Reference the Module**: In your Terraform configuration, reference the module and pass the JSON configuration file as input.

3. **Run Terraform Commands**:
   - Initialize the Terraform configuration: `terraform init`
   - Plan the Terraform configuration: `terraform plan`
   - Apply the Terraform configuration: `terraform apply`

This module will create and manage Azure Stream Analytics resources based on the provided configuration.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostic_management"></a> [diagnostic\_management](#module\_diagnostic\_management) | ../diag | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_stream_analytics_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_cluster) | resource |
| [azurerm_stream_analytics_job.job](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_job) | resource |
| [azurerm_stream_analytics_managed_private_endpoint.managed_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_managed_private_endpoint) | resource |
| [azurerm_stream_analytics_output_blob.output_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_output_blob) | resource |
| [azurerm_stream_analytics_output_eventhub.output_eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_output_eventhub) | resource |
| [azurerm_stream_analytics_stream_input_blob.input_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_stream_input_blob) | resource |
| [azurerm_stream_analytics_stream_input_eventhub.input_eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/stream_analytics_stream_input_eventhub) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clusters"></a> [clusters](#input\_clusters) | Map of Stream Analytics cluster configurations. | <pre>map(object({<br>    location            = string<br>    resource_group_name = string<br>    cluster_capacity    = number<br>  }))</pre> | n/a | yes |
| <a name="input_inputs"></a> [inputs](#input\_inputs) | Map of input configurations. | <pre>map(object({<br>    type                   = string<br>    eventhub_name          = optional(string)<br>    servicebus_namespace   = optional(string)<br>    consumer_group_name    = optional(string)<br>    storage_account_name   = optional(string)<br>    storage_container_name = optional(string)<br>    path_pattern           = optional(string)<br>    date_format            = optional(string)<br>    time_format            = optional(string)<br>    job_name               = string<br>  }))</pre> | n/a | yes |
| <a name="input_jobs"></a> [jobs](#input\_jobs) | Map of Stream Analytics job configurations. | <pre>map(object({<br>    location             = string<br>    resource_group_name  = string<br>    streaming_units      = number<br>    transformation_query = string<br>    cluster_name         = string<br>    storage_account_name = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_name_convention"></a> [name\_convention](#input\_name\_convention) | Naming convention details. | <pre>object({<br>    region                    = string<br>    name = string<br>    env                       = string<br>    cmdb_infra                = string<br>    cmdb_project              = string<br>  })</pre> | n/a | yes |
| <a name="input_opsmon_law_id"></a> [opsmon\_law\_id](#input\_opsmon\_law\_id) | The ID of the Operations Monitoring Law. | `string` | n/a | yes |
| <a name="input_outputs"></a> [outputs](#input\_outputs) | Map of output configurations. | <pre>map(object({<br>    type                   = string<br>    eventhub_name          = optional(string)<br>    servicebus_namespace   = optional(string)<br>    storage_account_name   = optional(string)<br>    storage_container_name = optional(string)<br>    path_pattern           = optional(string)<br>    date_format            = optional(string)<br>    time_format            = optional(string)<br>    job_name               = string<br>  }))</pre> | n/a | yes |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Map of managed private endpoint configurations. | <pre>map(object({<br>    job_name            = optional(string)<br>    cluster_name        = optional(string)<br>    resource_group_name = optional(string)<br>    subresource_name    = optional(string)<br>    target_resource_id  = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_secmon_law_id"></a> [secmon\_law\_id](#input\_secmon\_law\_id) | The ID of the Security Monitoring Law. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_private_endpoint_ids"></a> [managed\_private\_endpoint\_ids](#output\_managed\_private\_endpoint\_ids) | The IDs of the managed private endpoints. |
| <a name="output_managed_private_endpoint_names"></a> [managed\_private\_endpoint\_names](#output\_managed\_private\_endpoint\_names) | The names of the managed private endpoints. |
| <a name="output_managed_private_endpoint_target_resource_ids"></a> [managed\_private\_endpoint\_target\_resource\_ids](#output\_managed\_private\_endpoint\_target\_resource\_ids) | The target resource IDs of the managed private endpoints. |
| <a name="output_stream_analytics_cluster_id"></a> [stream\_analytics\_cluster\_id](#output\_stream\_analytics\_cluster\_id) | The IDs of the Stream Analytics clusters. |
| <a name="output_stream_analytics_cluster_name"></a> [stream\_analytics\_cluster\_name](#output\_stream\_analytics\_cluster\_name) | The names of the Stream Analytics clusters. |
| <a name="output_stream_analytics_job_id"></a> [stream\_analytics\_job\_id](#output\_stream\_analytics\_job\_id) | The IDs of the Stream Analytics jobs. |
| <a name="output_stream_analytics_job_identities"></a> [stream\_analytics\_job\_identities](#output\_stream\_analytics\_job\_identities) | The managed identity principal IDs of all Stream Analytics jobs. |
| <a name="output_stream_analytics_job_name"></a> [stream\_analytics\_job\_name](#output\_stream\_analytics\_job\_name) | The names of the Stream Analytics jobs. |
