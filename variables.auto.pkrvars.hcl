###############################################################################
# Name:             variables.pkrvars.hcl  
# Description:      Variables
# Author:           Daniel Whicker
# Date:             2022-11-29
###############################################################################

###############################################################################
# VM Hardware 
###############################################################################
vm-name             = "RHEL93-Template"
# https://code.vmware.com/apis/358/vsphere/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
vm-os-type          = "rhel9_64Guest"
vm-cpu-num          = 2
vm-cpu-hotplug      = true
vm-mem-size         = 4096
vm-mem-hotplug      = true
vm-network-card     = "vmxnet3"
vm-disk-size        = 40960
vm-disk-thin        = true
vm-disk-controller  = ["pvscsi"]
vm-firmware         = "efi-secure"

###############################################################################
# OS Info
###############################################################################
guest-username      = "root"
guest-password      = "P@ssw0rd"
guest-keyboard      = "us"
guest-timezone      = "America/Chicago"
guest-language      = "en_US"

###############################################################################
# OS Meta Data
###############################################################################
guest_os_family     = "Linux"
guest_os_vendor     = "RedHat"
guest_os_version    = "9.3"
guest_os_architecture = "x86_64"
guest_os_type       = "Server"
guest_os_edition    = "Minimal"

###############################################################################
# Installation Media
###############################################################################

# iso_checksum        = "none"
iso_checksum        = "sha256:5c802147aa58429b21e223ee60e347e850d6b0d8680930c4ffb27340ffb687a8"
iso_url             = "http://bifrost.viking.org/cdimages/Linux/RedHat/rhel-9.3-x86_64-dvd.iso"

http_directory      = "files/"

###############################################################################
# Provisioner Settings
###############################################################################
floppy_files = [
  "files/ks.cfg"
]

cd_label = "kickstart"
cd_files = [
  "files/ks.cfg"
]
  
script_files_group_1 = []

script_files_group_2 = []

phase2_inline = [
  "dnf update -y",
  "dnf clean all"
]