variable "bigip_details" {
  type = object({
    resource_group_name = string
    location            = string
    user_identity       = string
    credentials = object({
      username = string
      password = optional(string)
    })
    virtual_machine_details = object({
      instance_type        = string
      image_publisher      = string
      image_name           = string
      version              = string
      product_name         = string
      os_disk_size         = number
      storage_account_type = string
      availability_zone    = any
      enable_ssh_key       = bool
    })
    network = object({
      subnets = object({
        mgmt_subnet_ids = list(object({
          subnet_id          = string
          public_ip          = bool
          private_ip_primary = string
        }))
        external_subnet_ids = list(object({
          subnet_id            = string
          public_ip            = bool
          private_ip_primary   = string
          private_ip_secondary = optional(string)
        }))
        internal_subnet_ids = list(object({
          subnet_id          = string
          public_ip          = bool
          private_ip_primary = string
        }))
      })
      nsgs = optional(object({
        mgmt_securitygroup_ids         = list(string)
        external_securitygroup_ids     = list(string)
        internal_securitygroup_ids     = list(string)
        mgmt_app_securitygroup_ids     = list(string)
        external_app_securitygroup_ids = list(string)
        internal_app_securitygroup_ids = list(string)
      }))
      external_enable_ip_forwarding = bool
    }),
  })

  default = {
    location            = "West Europe"
    resource_group_name = ""
    user_identity       = null
    name_convention = {
      region                    = "we"
      name = "i"
      env                       = "dev"
      cmdb_infra                = "azus"
      cmdb_project              = "azus"
    }
    credentials = {
      username = "bigipuser"
    }
    virtual_machine_details = {
      instance_type        = "Standard_D8s_v4"
      image_publisher      = "f5-networks"
      image_name           = "f5-bigip-virtual-edition-25m-better-hourly"
      version              = "latest"
      product_name         = "f5-big-ip-better"
      os_disk_size         = 120
      storage_account_type = "Standard_LRS"
      availability_zone    = [1, 2, 3]
      enable_ssh_key       = false
    }
    network = {
      subnets = {
        mgmt_subnet_ids     = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
        external_subnet_ids = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null, "private_ip_secondary" = null }]
        internal_subnet_ids = [{ "subnet_id" = null, "public_ip" = null, "private_ip_primary" = null }]
      }
      external_enable_ip_forwarding = true
    }
  }
}

variable "name_convention" {
    type = object({
      region                    = string
      name = string
      env                       = string
      cmdb_infra                = string
      cmdb_project              = string
    })
}

variable "byol_reg_key" {
  type        = any
  description = "F5 BYOL registartion keys"
  sensitive   = true
}
variable "instances" {
  type        = number
  description = "number of f5 instances"
  default     = 2
}

variable "f5_ssh_publickey" {
  description = "public key to be used for ssh access to the VM. e.g. c:/home/id_rsa.pub"
}

variable "script_name" {
  type    = string
  default = "custom_do_byol"
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "DO_URL" {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.44.0/f5-declarative-onboarding-1.44.0-5.noarch.rpm"
  # default = "https://source.jfrog.io/F5-Local/f5-declarative-onboarding-1.31.0-6.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "AS3_URL" {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.51.0/f5-appsvcs-3.51.0-5.noarch.rpm"
  # default = "https://source.jfrog.io/F5-Local/f5-appsvcs-3.38.0-4.noarch.rpm"

}

## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "TS_URL" {
  description = "URL to download the BIG-IP Telemetry Streaming module"
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.35.0/f5-telemetry-1.35.0-1.noarch.rpm"
  # default = "https://source.jfrog.io/F5-Local/f5-telemetry-1.30.0-1.noarch.rpm"
}

## Please check and update the latest FAST URL from https://github.com/F5Networks/f5-appsvcs-templates/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "FAST_URL" {
  description = "URL to download the BIG-IP FAST module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.25.0/f5-appsvcs-templates-1.25.0-1.noarch.rpm"
  # default = "https://source.jfrog.io/F5-Local/f5-appsvcs-templates-1.18.0-1.noarch.rpm"
}

## Please check and update the latest Failover Extension URL from https://github.com/F5Networks/f5-cloud-failover-extension/releases/latest 
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "CFE_URL" {
  description = "URL to download the BIG-IP Cloud Failover Extension module"
  type        = string
  default     = "https://github.com/F5Networks/f5-cloud-failover-extension/releases/download/v2.1.1/f5-cloud-failover-2.1.1-1.noarch.rpm"
  # default = "https://source.jfrog.io/F5-Local/f5-cloud-failover-1.11.0-0.noarch.rpm"
}

## Please check and update the latest runtime init URL from https://github.com/F5Networks/f5-bigip-runtime-init/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "INIT_URL" {
  description = "URL to download the BIG-IP runtime init"
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v2.0.2/dist/f5-bigip-runtime-init-2.0.2-1.gz.run"
  # default = "https://source.jfrog.io/F5-Local/f5-bigip-runtime-init-1.5.1-1.gz.run"
}

variable "libs_dir" {
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
  default     = "/config/cloud/azure/node_modules"
  type        = string
}
variable "onboard_log" {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  default     = "/var/log/startup-script.log"
  type        = string
}

variable "custom_user_data" {
  description = "Provide a custom bash script or cloud-init script the BIG-IP will run on creation"
  type        = string
  default     = null
}


variable "tags" {
  description = "key:value tags to apply to resources built by the module"
  type        = map(any)
  default     = {}
}

variable "externalnic_failover_tags" {
  description = "key:value tags to apply to external nic resources built by the module"
  type        = any
  default     = {}
}

variable "internalnic_failover_tags" {
  description = "key:value tags to apply to internal nic resources built by the module"
  type        = any
  default     = {}
}

variable "cfe_secondary_vip_disable" {
  type        = bool
  description = "Disable Externnal Public IP Association to instance based on this flag (Usecase CFE Scenario)"
  default     = false
}
variable "sleep_time" {
  type        = string
  default     = "300s"
  description = "The number of seconds/minutes of delay to build into creation of BIG-IP VMs; default is 250. BIG-IP requires a few minutes to complete the onboarding process and this value can be used to delay the processing of dependent Terraform resources."
}
