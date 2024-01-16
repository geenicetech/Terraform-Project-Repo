
#this block creates a virtual network and subnets
resource "azurerm_virtual_network" "testvnet1" {
  name                = "testvnet1"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }
  depends_on = [ azurerm_resource_group.resource_group ]
}

