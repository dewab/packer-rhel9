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
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
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
  build_version  = formatdate("YY.MM", timestamp())
  build_date     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  vm_description = "Built automatically by Daniel Whicker's Packer scripts\nVER: ${local.build_version}\nDATE: ${local.build_date}\n"
  # VMware User-Data
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
  # Azure User-Data
  user_data = base64encode(templatefile("${abspath(path.root)}/files/user-data.azure.pkrtpl.hcl", {
    admin_username = var.admin_username
    admin_password = bcrypt(var.admin_password)
    guest_username = var.guest_username
    guest_password = bcrypt(var.guest_password)
    guest_keyboard = var.guest_keyboard
    guest_timezone = var.guest_timezone
    guest_language = var.guest_language
  }))

}

###############################################################################
# Source
###############################################################################

source "azure-arm" "template" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = var.arm_client_id
  client_secret                     = var.arm_client_secret
  tenant_id                         = var.arm_tenant_id
  subscription_id                   = var.arm_subscription_id
  image_offer                       = var.arm_image_offer
  image_publisher                   = var.arm_image_publisher
  image_sku                         = var.arm_image_sku
  image_version                     = var.arm_image_version
  location                          = var.arm_location
  managed_image_name                = var.vm_name
  managed_image_resource_group_name = var.arm_resource_group
  os_type                           = var.guest_os_family
  vm_size                           = var.arm_vm_size
  # user_data                         = local.user_data
  custom_data = local.user_data
}

source "vsphere-iso" "template" {
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
      name        = var.vsphere_content_library_name
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
  guest_os_type = var.vm_os_type
  CPU_hot_plug  = var.vm_cpu_hotplug
  CPUs          = var.vm_cpu_num
  RAM           = var.vm_mem_size
  RAM_hot_plug  = var.vm_mem_hotplug
  video_ram     = var.vm_video_ram
  firmware      = var.vm_firmware
  NestedHV      = var.vm_nested_hv
  vm_version    = var.vm_version
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
    network_card = var.vm_network_card
  }

  # Storage Configuration
  disk_controller_type = var.vm_disk_controller
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin
  }

  # vCenter Configuration
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = var.vsphere_insecure_connection

  # Remote Access
  communicator           = var.remote_communicator
  ssh_username           = var.guest_username
  ssh_password           = var.guest_password
  ssh_agent_auth         = var.vm_ssh_agent_auth
  ssh_timeout            = var.vm_ssh_timeout
  ssh_handshake_attempts = var.vm_ssh_handshake_attempts
  ip_wait_timeout        = var.vm_ip_timeout
  shutdown_timeout       = var.vm_shutdown_timeout
  shutdown_command       = "echo '${var.guest_password}' | sudo -S shutdown -h now"

  boot_wait    = var.boot_wait
  boot_command = var.boot_command
}

###############################################################################
# Build
###############################################################################

build {
  sources = [
    "source.azure-arm.template",
    "source.vsphere-iso.template"
  ]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; echo ${var.guest_password} | {{ .Vars }} sudo -SE sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    env = {
      REDHAT_USERNAME : var.redhat_username
      REDHAT_PASSWORD : var.redhat_password
    }
    scripts = var.script_files_group_1
  }

  hcp_packer_registry {
    bucket_name = var.hcp_bucket_name
    description = <<EOT
      Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "owner"                 = "platform-team"
      "os-vendor"             = var.guest_os_vendor
      "os-type"               = var.guest_os_type
      "os-version"            = var.guest_os_version
      "os-edition"            = var.guest_os_edition
      "build-time"            = timestamp()
      "build-source"          = basename(path.cwd)
      "network-configuration" = "DHCP"
    }
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
