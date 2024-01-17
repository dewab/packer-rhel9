###############################################################################
# Name:             windows.pkr.hcl
# Description:      Packer Build Definition for Windows 10 Professional
# Author:           Daniel Whicker
# Date:             2021-05-29
###############################################################################

# The plan with this build is to split installation, patching, and 
# customization across separate iterations of packer.  We can then re-use the
# initial base install over multiple iterations of patching and customizing

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
    build_version               = formatdate("YY.MM", timestamp())
    build_date                  = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    cd_content                  = {
        "ks.cfg" = templatefile("${abspath(path.root)}/files/ks.pkrtpl.hcl", {
            guest_password = var.guest_password
            guest_username = var.guest_username
            guest_keyboard = var.guest_keyboard
            guest_timezone = var.guest_timezone
            guest_language = var.guest_language
          })
      }
    vm_description              = "Built automatically by Daniel Whicker's Packer scripts\nVER: ${ local.build_version }\nDATE: ${ local.build_date }\n"
}

###############################################################################
# Source
###############################################################################

source "vsphere-iso" "rhel9" {
  # VMware Targets
  cluster              = var.vsphere_cluster
  convert_to_template  = "true"
  create_snapshot      = "true"
  snapshot_name        = "phase1"
  datacenter           = var.vsphere_datacenter
  datastore            = var.vsphere_datastore
  folder               = var.vsphere_folder
  vm_name              = "${var.vm_name}"
  notes                = local.vm_description
  dynamic "content_library_destination" {
    for_each = var.vsphere_content_library != null ? [1] : []
        content {
            library         = var.vsphere_content_library
            # name            = "${ source.name }"
            name            = var.vm_name
            description     = local.vm_description
            ovf             = var.vsphere_content_library_ovf
            destroy         = var.vsphere_content_library_destroy
            skip_import     = var.vsphere_content_library_skip
        }
  }
  
  # VMware Hardware Configuration
  guest_os_type        = var.vm-os-type
  CPU_hot_plug         = var.vm-cpu-hotplug
  CPUs                 = var.vm-cpu-num
  RAM                  = var.vm-mem-size
  RAM_hot_plug         = var.vm-mem-hotplug
  video_ram            = var.vm-video-ram
  firmware             = var.vm-firmware
  NestedHV             = var.vm-nested-hv
  vm_version           = var.vm-version
  cd_content           = local.cd_content
  cd_files             = [ "files/test.txt" ]

  # Installation Media
  iso_checksum         = var.iso_checksum
  iso_url              = var.iso_url
  // iso_paths            = ["[] /vmimages/tools-isoimages/linux.iso"]
  // iso_paths            = []
  
  # Network Configuration
  network_adapters {
    network = var.vsphere_network
    network_card = var.vm-network-card
  }

  # Storage Configuration
  disk_controller_type = var.vm-disk-controller  
  storage {
    disk_size = var.vm-disk-size
    disk_thin_provisioned = var.vm-disk-thin
  }

  # vCenter Configuration
  vcenter_server       = var.vsphere_server
  username             = var.vsphere_user
  password             = var.vsphere_password
  insecure_connection  = var.vsphere_insecure_connection
    
  # Remote Access
  communicator         = "ssh"  
  ssh_username         = var.guest_username
  ssh_password         = var.guest_password
  ssh_agent_auth       = "true"
  ssh_timeout          = var.vm_ssh_timeout
  ip_wait_timeout      = var.vm_ip_timeout
  shutdown_timeout     = var.vm_shutdown_timeout
  shutdown_command     = "sudo shutdown -P now"

  # Below is to share the kickstart file
  // http_directory       = var.http_directory

  # Below is required to boot ISO with EFI
  boot_wait            = "3s"
  boot_command         = [
    // "<up>e<down><down><end> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<leftCtrlOn>x<leftCtrlOff>"
    "<up>e<down><down><end> inst.text inst.ks=cdrom <leftCtrlOn>x<leftCtrlOff>"
  ]
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
      "owner"                       = "platform-team"
      "os"                          = "Red Hat Enterprise Linux"
      "redhat-version"              = "9.3"
    }

    build_labels = {
      "build-time"                            = timestamp()
      "build-source"                          = basename(path.cwd)
      "network-configuration"                 = "DHCP"
    }
  }

  sources = ["source.vsphere-iso.rhel9"]
  
  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      vsphere_cluster = var.vsphere_cluster
      vsphere_datacenter = var.vsphere_datacenter
      vsphere_datastore = var.vsphere_datastore
      vsphere_folder = var.vsphere_folder
      vsphere_network = var.vsphere_network
      iso_url = var.iso_url
      iteration_id = packer.iterationID
      guest_os_family = var.guest_os_family
      guest_os_architecture = var.guest_os_architecture
      guest_os_vendor = var.guest_os_vendor
      guest_os_version = var.guest_os_version
      guest_os_edition = var.guest_os_edition
      guest_os_type = var.guest_os_type
    }
  }
}
