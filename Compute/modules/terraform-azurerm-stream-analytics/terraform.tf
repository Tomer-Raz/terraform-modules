# Declare the required provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.15.0"

    }
  }
}

