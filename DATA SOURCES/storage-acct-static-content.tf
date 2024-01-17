resource "azurerm_storage_account" "Storage_account" {
  name                     = "storagegee2"
  resource_group_name      = local.resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [azurerm_resource_group.resource_group]
}

resource "azurerm_storage_container" "container1" {
  name                  = "container1"
  storage_account_name  = azurerm_storage_account.Storage_account.name
  container_access_type = "blob"
  depends_on = [azurerm_storage_account.Storage_account]
}

resource "azurerm_storage_blob" "iis_config" {
  name                   = "iis-config.ps1"
  storage_account_name   = azurerm_storage_account.Storage_account.name
  storage_container_name = "container1"
  type                   = "Block"
  source                 = "iis-config.ps1"
  depends_on = [ azurerm_storage_container.container1 ]
}

resource "azurerm_storage_blob" "cloud_image" {
  name                   = "cloud-image.jpg"
  storage_account_name   = azurerm_storage_account.Storage_account.name
  storage_container_name = "container1"
  type                   = "Block"
  source                 = "cloud-image.jpg"
  depends_on = [ azurerm_storage_container.container1 ]
}

resource "azurerm_storage_blob" "upload-web-app" {
  name                   = "upload-web-app.ps1"
  storage_account_name   = azurerm_storage_account.Storage_account.name
  storage_container_name = "container1"
  type                   = "Block"
  source                 = "upload-web-app.ps1"
  depends_on = [ azurerm_storage_container.container1 ]
}