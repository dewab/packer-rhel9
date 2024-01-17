provider "vsphere" {
    user = var.vsphere_user
    password = var.vsphere_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

variable "iteration_id" {
  description = "HCP Packer Iteration ID"
}

data "hcp_packer_image" "vm_clone" {
  bucket_name = "redhat"
  cloud_provider = "vsphere"
  region = "Lab"
  iteration_id = var.iteration_id
  # channel = "latest"
}

data "vsphere_datacenter" "dc" {
    name = var.vsphere_datacenter
}

data "vsphere_datastore" "ds" {
    name = var.vsphere_datastore
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name = var.vsphere_network
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name = var.vsphere_cluster
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name = data.hcp_packer_image.vm_clone.cloud_image_id
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_tag_category" "environment" {
  name = "environment"
}

data "vsphere_tag" "development" {
  name          = "development"
  category_id   = data.vsphere_tag_category.environment.id
}

resource "vsphere_virtual_machine" "vm_clone" {
    name = "test_vm"
    resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id = data.vsphere_datastore.ds.id
    folder = var.vsphere_folder

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
        size = data.vsphere_virtual_machine.template.disks.0.size
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
        linked_clone = true
    }

    tags = [ data.vsphere_tag.development.id ]

    connection {
      type = "ssh"
      user = "root"
      password = "P@ssw0rd"
      host     = vsphere_virtual_machine.vm_clone.default_ip_address
      # This is needed as terraform defaults to scripts in /tmp which is mounted noexec in a hardened image
      script_path = "/root/terraform.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "sleep 60",
        "subscription-manager register --username=${var.guest_redhat_user} --password=${var.guest_redhat_password}",
        "yum install -y nginx",
        "systemctl start nginx",
        "firewall-cmd --add-service=http",
        "subscription-manager unregister"
      ]
    }
}
