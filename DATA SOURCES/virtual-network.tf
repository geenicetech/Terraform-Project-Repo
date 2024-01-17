#this block creates a virtual network and subnet


resource "azurerm_virtual_network" "project-vnet1" {
  name                = "project-vnet1"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.project-nsg1.id
  }
  depends_on = [ azurerm_resource_group.resource_group ]
}
