terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.87.0"
    }
  }
}

provider "azurerm" {
 subscription_id = ""
 client_id = ""
 tenant_id = ""
 client_secret = ""
 features {}
}
data "azurerm_subnet" "subnet1" {
  name = "subnet1"
  resource_group_name = local.resource_group
  virtual_network_name = azurerm_virtual_network.project-vnet1.name
}


locals {
  resource_group = "project1-rg"
  location = "east us"
}

resource "azurerm_resource_group" "resource_group" {
  name = "project1-rg"
  location = "east us"
}
