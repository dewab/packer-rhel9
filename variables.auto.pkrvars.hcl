###############################################################################
# Name:             variables.pkrvars.hcl
# Description:      Variables
# Author:           Daniel Whicker
# Date:             2022-11-29
###############################################################################

###############################################################################
# VM Hardware
###############################################################################
# https://code.vmware.com/apis/358/vsphere/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
vm_name            = "RHEL9-Template"
vm_os_type         = "rhel9_64Guest"
vm_cpu_num         = 2
vm_cpu_hotplug     = true
vm_mem_size        = 4096
vm_mem_hotplug     = true
vm_network_card    = "vmxnet3"
vm_disk_size       = 40960
vm_disk_thin       = true
vm_disk_controller = ["pvscsi"]
vm_firmware        = "efi-secure"

###############################################################################
# Azure Configuration
###############################################################################
arm_image_publisher = "RedHat"
arm_image_offer     = "RHEL"
arm_image_sku       = "9_3"
arm_image_version   = "latest"
arm_resource_group  = "rg-1"
arm_vm_size         = "Standard_DS2_v2"
arm_location        = "eastus"
# arm_managed_image_name  = var.vm_name

###############################################################################
# OS Info
###############################################################################
guest_keyboard = "us"
guest_timezone = "America/Chicago"
guest_language = "en_US"

###############################################################################
# OS Meta Data
###############################################################################
guest_os_family       = "Linux"
guest_os_vendor       = "RedHat"
guest_os_version      = "9.3"
guest_os_architecture = "x86_64"
guest_os_type         = "Server"
guest_os_edition      = "Minimal"
hcp_bucket_name       = "redhat"

###############################################################################
# Installation Media
###############################################################################

# iso_checksum = "none"
iso_checksum = "sha256:5c802147aa58429b21e223ee60e347e850d6b0d8680930c4ffb27340ffb687a8"
iso_url      = "https://filebrowser.home.bifrost.cc/api/public/dl/lEn5J2-a/cdimages/Linux/RedHat/rhel-9.3-x86_64-dvd.iso"

http_directory = "files/"
boot_wait      = "3s"
boot_command = [
  "<up>e<down><down><end> inst.text inst.ks=cdrom <leftCtrlOn>x<leftCtrlOff>"
]

###############################################################################
# Provisioner Settings
###############################################################################
remote_communicator = "ssh" # "none", "ssh", "winrm"
floppy_files        = []
cd_label            = "kickstart"
cd_files            = []
script_files_group_1 = [
  "files/00_subscription_manager.sh",
  "files/01_update_all.sh",
  "files/02_customization.sh",
  "files/99_cleanup.sh"
]
inline_commands = []
