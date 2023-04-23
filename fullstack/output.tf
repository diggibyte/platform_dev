output "tls_private_keys" {
  value     = module.fs-virtual-machine-dev[*]
  sensitive = true
}