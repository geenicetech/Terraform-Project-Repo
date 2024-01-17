
resource "azurerm_network_security_group" "project-nsg1" {
   name                = "project-nsg"
  location            = local.location
  resource_group_name = local.resource_group


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

  depends_on = [ azurerm_resource_group.resource_group ]
}