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
virtual_network_name = azurerm_virtual_network.testvnet1.name
depends_on = [ azurerm_virtual_network.testvnet1 ]
}



locals {
  resource_group = "rg1"
  location = "east us"
}
resource "azurerm_resource_group" "resource_group" {
  name = local.resource_group
  location = local.location
}



resource "azurerm_network_interface" "testinterface" {
  name                = "testinterface"
  location            =local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.testip.id
  }
  depends_on = [ azurerm_virtual_network.testvnet1, azurerm_public_ip.testip ]
}

resource "azurerm_windows_virtual_machine"  "testvm" {
  name                = "testvm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_DS1_V2"
  admin_username      = "geenice"
  admin_password      = "azure@1234"
  network_interface_ids = [
    azurerm_network_interface.testinterface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_network_interface.testinterface ]
  
}

resource "azurerm_public_ip" "testip" {
  name                = "testip"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ azurerm_virtual_network.testvnet1 ]
}