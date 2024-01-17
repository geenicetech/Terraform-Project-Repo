terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.87.0"
    }
  }
}

provider "azurerm" {
 subscription_id = "2073be91-9975-4a72-9511-8f8906661003"
 client_id = "bc31c9da-ea03-45c9-a633-678a72c8b75f"
 tenant_id = "90f76f03-ef55-4102-a616-5b4235d4b5a7"
 client_secret = "upX8Q~iuJPiGGB~rxQnfir.sNxnnrX9zPAHNgcZC"
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
