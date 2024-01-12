output "health_endpoint" {
  value = "http://${vsphere_virtual_machine.vm_clone.default_ip_address}/"
}
