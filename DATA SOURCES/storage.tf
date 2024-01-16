resource "azurerm_storage_account" "storage_account" {
  name                     = "storagegee2"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [azurerm_resource_group.resource_group]
}

#this block is used to create a container
resource "azurerm_storage_container" "container1" {
  name                  = "container1"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "blob"
  depends_on = [azurerm_storage_account.storage_account]
}

#this block is used to add the blob
resource "azurerm_storage_blob" "myfile" {
  name                   = "AZ-104 study guide.docx"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "container1"
  type                   = "Block"
  source                 = "AZ-104 study guide.docx"
  depends_on = [ azurerm_storage_container.container1 ]
}