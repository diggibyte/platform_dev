locals {
  config_file_path            = "${path.root}/fullstack/config/"
  resource_config             = jsondecode(file("${local.config_file_path}/resource_details.json"))
  virtual_network_instances   = local.resource_config.virtual_networks
  subnet_instances            = local.resource_config.virtual_subnets
  network_interface_instances = local.resource_config.virtual_network_interface
  virtual_machine_instances   = local.resource_config.virtual_machines
  key_vault_instances         = local.resource_config.key_vaults
  public_ip_instances         = local.resource_config.public_ips

}

module "fs-kv-dev" {
  for_each            = { for inst in local.key_vault_instances : inst.name => inst }
  source              = "../platform_tfmodules/global/keyVault"
  key_vault_name      = each.value.name
  tenant_id           = var.TENANT_ID
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku
  key_permissions     = each.value.key_permissions
  secret_permissions  = each.value.secret_permissions
  storage_permissions = each.value.storage_permissions
}

module "fs-virtual-network-dev" {
  for_each      = { for inst in local.virtual_network_instances : inst.name => inst }
  source        = "../platform_tfmodules/global/virtualNetwork"
  vn_name       = each.value.name
  rg_name       = each.value.resource_group_name
  address_space = each.value.address_space
  tags          = each.value.tags
}

module "fs-subnet-dev" {
  for_each         = { for inst in local.subnet_instances : inst.name => inst }
  source           = "../platform_tfmodules/global/subnet"
  subnet_name      = each.value.name
  rg_name          = each.value.resource_group_name
  vn_name          = each.value.virtual_network_name
  address_prefixes = each.value.address_prefixes
}

module "fs-virtual-network_interface-dev" {
  for_each               = { for inst in local.network_interface_instances : inst.name => inst }
  source                 = "../platform_tfmodules/global/networkInterface"
  network_interface_name = each.value.name
  rg_name                = each.value.resource_group_name
  ip_config_name         = each.value.ip_config_name
  subnet_id              = module.fs-subnet-dev[each.value.subnet_name].subnet_id
  public_ip              = lookup(each.value, "public_ip", "") == "" ? "" : module.fs-public-ip-dev[each.value.public_ip].ip_address_id
}

module "fs-public-ip-dev" {
  for_each      = { for inst in local.public_ip_instances : inst.name => inst }
  source        = "../platform_tfmodules/global/public_ip"
  public_ip_obj = each.value
}
module "fs-virtual-machine-dev" {
  for_each                  = { for inst in local.virtual_machine_instances : inst.name => inst }
  source                    = "../platform_tfmodules/global/virtualMachine/linux"
  vm_name                   = each.value.name
  rg_name                   = each.value.resource_group_name
  size                      = each.value.size
  admin_username            = each.value.admin_username
  network_interface_ids     = [for vin in each.value.network_interface_names : module.fs-virtual-network_interface-dev[vin].network_interface_id]
  username                  = each.value.admin_username
  disk_caching              = each.value.os_disk.caching
  disk_storage_account_type = each.value.os_disk.storage_account_type
  publisher                 = each.value.source_image_reference.publisher
  offer                     = each.value.source_image_reference.offer
  sku                       = each.value.source_image_reference.sku
  image_version             = each.value.source_image_reference.version
}

module "kv-vm-admin-passwords" {
  for_each     = { for inst in local.virtual_machine_instances : inst.name => inst }
  source       = "../platform_tfmodules/global/keyVaultSecret"
  secret_name  = "${each.value.name}-ADMIN-PASSWORD"
  secret_value = module.fs-virtual-machine-dev[each.value.name].admin_password
  key_vault_id = module.fs-kv-dev[each.value.key_vault].key_vault_id
}