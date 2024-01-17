
resource "azurerm_public_ip" "project-PIP" {
  name                = "project-PIP"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.resource_group ]
}

resource "azurerm_network_interface" "project-nic" {
  name                = "project-nic"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.project-PIP.id
  }

  depends_on = [ 
    azurerm_virtual_network.project-vnet1,
    azurerm_public_ip.project-PIP
    ]
}


resource "azurerm_windows_virtual_machine" "project-vm" {
  name                = "project-vm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_DS1_V2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.project-nic.id,
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

  depends_on = [ azurerm_network_interface.project-nic ]
}

resource "azurerm_virtual_machine_extension" "project-vm-extension" {
  name                 = "project-vm-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.project-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

    settings = <<SETTINGS
{
"fileUris": ["https://${azurerm_storage_account.Storage_account.name}.blob.core.windows.net/container1/iis-config.ps1"],
 "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file iis-config.ps1"
}
SETTINGS
} 

