data "azurerm_client_config" "current" {
}

module "fs_resources" {
  source    = "./fullstack"
  TENANT_ID = data.azurerm_client_config.current.tenant_id
}

module "dl_resources" {
  source    = "./datalake"
  TENANT_ID = data.azurerm_client_config.current.tenant_id
}