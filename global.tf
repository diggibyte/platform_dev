terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "DGB-RG-PF-001"
    storage_account_name = "dgbstpf001"
    container_name       = "tfdev"
    key                  = "datalake/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_keys_on_destroy = false
      purge_soft_delete_on_destroy       = true
      recover_soft_deleted_key_vaults    = true
    }
  }
  subscription_id = var.SUBSCRIPTION_ID
  client_id       = var.CLIENT_ID
  client_secret   = var.CLIENT_SECRET
  tenant_id       = var.TENANT_ID
}