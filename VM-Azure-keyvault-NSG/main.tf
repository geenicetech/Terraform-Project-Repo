terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.63.0"
    }
  }
}

provider "azurerm" {
 client_id = ""
 tenant_id = ""
 client_secret = ""
 subscription_id = ""
 features {
   key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
 }
}


data "azurerm_client_config" "current" {}

data "azurerm_subnet" "subnet-A" {
  name = "subnet-A"
  resource_group_name = local.rgname
  virtual_network_name = local.vnetname
  depends_on = [ azurerm_virtual_network.vnet1 ]
}
locals {
  location = "east us"
  rgname = "trial-rg"
  vnetname = "vnet1"
  pip-name = "pip-vm1"
  nic = "vm-nic"
  vm-name = "vm1"
  nsg-name = "nsg1"
  subnet-name = "subnet-A"
}

resource "azurerm_resource_group" "trial-rg" {
  name = local.rgname
  location = local.location
}


resource "azurerm_virtual_network" "vnet1" {
 name                = local.vnetname
  location            = local.location
  resource_group_name = local.rgname
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet-A"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.nsg1.id
  }
depends_on = [ azurerm_network_security_group.nsg1 ]
}

resource "azurerm_public_ip" "pip-vm1" {
  name                = local.pip-name
  resource_group_name = local.rgname
  location            = local.location
  allocation_method   = "Static"
  depends_on = [ azurerm_virtual_network.vnet1 ]
}

resource "azurerm_network_interface" "vm-nic" {
    name                = local.nic
  location            = local.location
  resource_group_name = local.rgname
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet-A.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-vm1.id
    
  }
  
  depends_on = [ azurerm_public_ip.pip-vm1 ]
}

resource "azurerm_windows_virtual_machine" "vm1" {
    name                = local.vm-name
  resource_group_name = local.rgname
  location            = local.location
  size                = "Standard_DS1_v2"
  admin_username      = "security"
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.vm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  depends_on = [ azurerm_network_interface.vm-nic, azurerm_key_vault_secret.vmpassword ]
}


resource "azurerm_network_security_group" "nsg1" {
   name                = local.nsg-name
  location            = local.location
  resource_group_name = local.rgname


  security_rule {
    name                       = "Allow-port80"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    
  }

   security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    
  }

  depends_on = [ azurerm_resource_group.trial-rg ]
}




resource "azurerm_key_vault" "geevault2a" {
  name                        = "geevault2a"
  location                    = local.location
  resource_group_name         = local.rgname
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id


    key_permissions = [
      "Get",
    ]

     secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
  depends_on = [ azurerm_resource_group.trial-rg ]
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = "Infinixnote8"
  key_vault_id = azurerm_key_vault.geevault2a.id
  depends_on = [ azurerm_key_vault.geevault2a ]
}
