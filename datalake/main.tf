locals {
  config_file_path = "${path.root}/datalake/config/"
  resource_config  = jsondecode(file("${local.config_file_path}/resource_details.json"))

  azure_databrick_instances    = local.resource_config.auzure_databricks
  azure_data_factory_instances = local.resource_config.azure_data_factories
  adls_gen_2_instances         = local.resource_config.adls_gen_2
  key_vault_instances          = local.resource_config.key_vaults
}

module "dl-st-dev" {
  for_each            = { for inst in local.adls_gen_2_instances : inst.name => inst }
  source              = "../platform_tfmodules/global/adlsGen2"
  resource_group_name = each.value.resource_group_name
  storage_name        = each.value.name
}

module "dl-kv-dev" {
  for_each       = { for inst in local.key_vault_instances : inst.name => inst }
  source         = "../platform_tfmodules/global/keyVault"
  key_vault_name = each.value.name
  tenant_id      = var.TENANT_ID
  sku_name       = each.value.sku
}

module "dl-db-dev" {
  for_each            = { for inst in local.azure_databrick_instances : inst.name => inst }
  source              = "../platform_tfmodules/datalake/databricks/azure-databricks-workspace"
  workspace_name      = each.value.name
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  advanced_config     = each.value.advanced_config
  location            = each.value.location
}

module "dl-adf-dev" {
  for_each = { for inst in local.azure_data_factory_instances : inst.name => inst }
  source   = "../platform_tfmodules/datalake/adf"
  adf_name = each.value.name
  location = lookup(each.value, "location", "Central India")
}