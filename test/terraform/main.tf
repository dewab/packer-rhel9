terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.6.1"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.83.0"
    }
  }
  required_version = ">= 1.7"
}

provider "vsphere" {
  user                 = var.vsphere_usernamename
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

variable "iteration_id" {
  description = "HCP Packer Iteration ID"
  type        = string
}

data "hcp_packer_version" "vm_clone" {
  bucket_name  = "redhat"
  channel_name = "latest"
}

data "hcp_packer_artifact" "vm_clone" {
  bucket_name         = "redhat"
  platform            = "vsphere"
  region              = var.vsphere_datacenter
  version_fingerprint = data.hcp_packer_version.vm_clone.fingerprint
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "ds" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = data.hcp_packer_artifact.vm_clone.external_identifier
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm_clone" {
  name             = "${data.vsphere_virtual_machine.template.name}-${var.iteration_id}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder           = var.vsphere_folder

  num_cpus = data.vsphere_virtual_machine.template.num_cpus
  memory   = data.vsphere_virtual_machine.template.memory
  firmware = data.vsphere_virtual_machine.template.firmware
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks[0].size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = true
  }

  connection {
    type     = "ssh"
    user     = var.guest_username
    password = var.guest_password
    host     = vsphere_virtual_machine.vm_clone.default_ip_address
    # This is needed as terraform defaults to scripts in /tmp which is mounted noexec in a hardened image
    script_path = "/home/${var.guest_username}/terraform.sh"
    timeout     = "30m"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "echo '${var.guest_password}' | sudo -S subscription-manager register --username=${var.redhat_username} --password=${var.redhat_password}",
      "echo '${var.guest_password}' | sudo -S yum install -y nginx",
      "echo '${var.guest_password}' | sudo -S systemctl start nginx",
      "echo '${var.guest_password}' | sudo -S firewall-cmd --add-service=http",
      "echo '${var.guest_password}' | sudo -S subscription-manager unregister"
    ]
  }
}
