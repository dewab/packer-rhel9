###############################################################################
# Name:             build.pkr.hcl
# Description:      Packer Build Definition for Linux
# Author:           Daniel Whicker
###############################################################################

###############################################################################
#  Dependencies
###############################################################################

packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vsphere = {
      version = ">= v1.1.1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

###############################################################################
# Variables
###############################################################################

locals {
  build_version = formatdate("YY.MM", timestamp())
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  cd_content = {
    "ks.cfg" = templatefile("${abspath(path.root)}/files/ks.pkrtpl.hcl", {
      admin_username = var.admin_username
      admin_password = bcrypt(var.admin_password)
      guest_username = var.guest_username
      guest_password = bcrypt(var.guest_password)
      guest_keyboard = var.guest_keyboard
      guest_timezone = var.guest_timezone
      guest_language = var.guest_language
    })
  }
  vm_description = "Built automatically by Daniel Whicker's Packer scripts\nVER: ${local.build_version}\nDATE: ${local.build_date}\n"
}

###############################################################################
# Source
###############################################################################

source "vsphere-iso" "rhel9" {
  # VMware Targets
  cluster             = var.vsphere_cluster
  convert_to_template = "true"
  create_snapshot     = "true"
  snapshot_name       = "phase1"
  vm_name             = var.vm_name
  datacenter          = var.vsphere_datacenter
  datastore           = var.vsphere_datastore
  folder              = var.vsphere_folder
  notes               = local.vm_description
  # Populate the source with the content library if it is defined
  dynamic "content_library_destination" {
    for_each = var.vsphere_content_library != null ? [1] : []
    content {
      library     = var.vsphere_content_library
      name        = var.vm_name
      description = local.vm_description
      ovf         = var.vsphere_content_library_ovf
      destroy     = var.vsphere_content_library_destroy
      skip_import = var.vsphere_content_library_skip
    }
  }
  # Export the OVF to the specified path if it is defined
  dynamic "export" {
    for_each = var.ovf_export_path != null ? [1] : []
    content {
      output_directory = var.ovf_export_path
      force            = true
    }
  }

  # VMware Hardware Configuration
  guest_os_type = var.vm-os-type
  CPU_hot_plug  = var.vm-cpu-hotplug
  CPUs          = var.vm-cpu-num
  RAM           = var.vm-mem-size
  RAM_hot_plug  = var.vm-mem-hotplug
  video_ram     = var.vm-video-ram
  firmware      = var.vm-firmware
  NestedHV      = var.vm-nested-hv
  vm_version    = var.vm-version
  cd_content    = local.cd_content
  cd_label      = var.cd_label
  cd_files      = var.cd_files

  # Installation Media
  iso_checksum = var.iso_checksum
  iso_url      = var.iso_url
  // iso_paths = ["[] /vmimages/tools-isoimages/linux.iso"]

  # Network Configuration
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm-network-card
  }

  # Storage Configuration
  disk_controller_type = var.vm-disk-controller
  storage {
    disk_size             = var.vm-disk-size
    disk_thin_provisioned = var.vm-disk-thin
  }

  # vCenter Configuration
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  # Remote Access
  communicator           = "ssh"
  ssh_username           = var.guest_username
  ssh_password           = var.guest_password
  ssh_agent_auth         = var.vm_ssh_agent_auth
  ssh_timeout            = var.vm_ssh_timeout
  ssh_handshake_attempts = var.vm_ssh_handshake_attempts
  ip_wait_timeout        = var.vm_ip_timeout
  shutdown_timeout       = var.vm_shutdown_timeout
  shutdown_command       = "echo '${var.guest_password}' | sudo -S shutdown -h now"

  boot_wait    = "3s"
  boot_command = var.boot_command
}

###############################################################################
# Build
###############################################################################

build {
  hcp_packer_registry {
    bucket_name = "redhat"
    description = <<EOT
      Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "owner"      = "platform-team"
      "os-vendor"  = var.guest_os_vendor
      "os-type"    = var.guest_os_type
      "os-version" = var.guest_os_version
      "os-edition" = var.guest_os_edition
    }

    build_labels = {
      "build-time"            = timestamp()
      "build-source"          = basename(path.cwd)
      "network-configuration" = "DHCP"
    }
  }

  sources = ["source.vsphere-iso.rhel9"]

  provisioner "shell" {
    # Variables cannot be passed through from the pkrvars file to this script -- they need to be set here.
    inline = [
      "echo '${var.guest_password}' | sudo -S subscription-manager register --username=${var.guest_redhat_user} --password=${var.guest_redhat_password}",
      "echo '${var.guest_password}' | sudo -S yum update -y",
      "echo '${var.guest_password}' | sudo -S subscription-manager unregister"
    ]
    remote_folder = "/home/${var.guest_username}/"
  }

  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      vsphere_cluster       = var.vsphere_cluster
      vsphere_datacenter    = var.vsphere_datacenter
      vsphere_datastore     = var.vsphere_datastore
      vsphere_folder        = var.vsphere_folder
      vsphere_network       = var.vsphere_network
      iso_url               = var.iso_url
      iteration_id          = packer.iterationID
      guest_os_family       = var.guest_os_family
      guest_os_architecture = var.guest_os_architecture
      guest_os_vendor       = var.guest_os_vendor
      guest_os_version      = var.guest_os_version
      guest_os_edition      = var.guest_os_edition
      guest_os_type         = var.guest_os_type
    }
  }
}
