variable "pip_name" {
  type = list 
  default = ["Test-pip", "Prod-pip"]
}
variable "avvm_name" {
  type = list 
  default = ["avvm1", "avvm2"]
}
variable "nic_name" {
  type = list 
  default = ["avnic1", "avnic2"]
}
resource "azurerm_availability_set" "avset1" {
  name                = "avset1"
  location            = local.location
  resource_group_name = local.resource_group

  tags = {
    environment = "Production"
  }
  depends_on = [ azurerm_resource_group.resource_group ]
}

resource "azurerm_network_interface" "avinterface" {
  name                = var.nic_name[count.index]
  location            =local.location
  resource_group_name = local.resource_group
  count = 2

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.avpip[count.index].id
  }
  depends_on = [ azurerm_virtual_network.testvnet1, azurerm_public_ip.testip ]
}

resource "azurerm_windows_virtual_machine"  "avvm" {
  name                = var.avvm_name[count.index]
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_DS1_V2"
  admin_username      = "geenice"
  admin_password      = "azure@1234"
  count = 2
  availability_set_id = azurerm_availability_set.avset1.id
  network_interface_ids = [
    azurerm_network_interface.avinterface[count.index].id
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
  depends_on = [ azurerm_network_interface.avinterface, azurerm_availability_set.avset1 ]
  
}

resource "azurerm_public_ip" "avpip" {
  name                = var.pip_name[count.index]
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  count = 2
  depends_on = [ azurerm_virtual_network.testvnet1 ]
}