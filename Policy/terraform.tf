terraform {
  required_version = ">=1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.11.0, <4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "097f24e6-7d2c-439a-b79e-1029c5ed0fa0"
}
# Alias provider for subscription1 subscription
provider "azurerm" {
  features {}
  alias           = "Spoke"
  subscription_id = "014a3d4b-7ecb-4f5d-b83b-37fee56640f2"
}