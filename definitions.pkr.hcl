###############################################################################
# Name:             variable_defs.pkr.hcl
# Description:      Variable Definitions
# Author:           Daniel Whicker
# Date:             2021-05-29
###############################################################################

variable "template" {
  type = string
  default = ""
}

variable "http_directory" {
  type = string
  default = ""
}

variable "vsphere_server" {
  type = string
  default = ""
  sensitive = false
}

variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
  sensitive = false
}

variable "vsphere_password" {
  type = string
  default = ""
  sensitive = true
}

variable "vsphere_datacenter" {
  type = string
  default = ""
  sensitive = false
}

variable "vsphere_cluster" {
  type = string
  default = ""
  description = "The VMware Cluster name to build the Template"
  sensitive = false
}

variable "vsphere_network" {
  type = string
  default = ""
  description = "The VMware PortGroup name to build the Template"
  sensitive = false
}

variable "vsphere_datastore" {
  type = string
  default = ""
  description = "The VMware Datastore name to place the Template"
  sensitive = false
}

variable "vsphere_folder" {
  type = string
  default = ""
  description = "The VMware Folder Name name to place the Template"
  sensitive = false
}

variable "vsphere_insecure_connection" {
  type = bool
  default = "true"
  description = "Should the connection to vCenter be insecure? (true/false)"
  sensitive = false
}

# vSphere Content Library and Template Configuration
variable "vsphere_convert_template" {
    type = bool
    description = "Convert the VM to a template?"
    default = false
}
variable "vsphere_content_library" {
    type = string
    description = "Name of the vSphere Content Library to export the VM to"
    default = null
}
variable "vsphere_content_library_ovf" {
    type = bool
    description = "Export to Content Library as an OVF file?"
    default = true
}
variable "vsphere_content_library_destroy" {
    type = bool
    description = "Delete the VM after successfully exporting to a Content Library?"
    default = true
}
variable "vsphere_content_library_skip" {
    type = bool
    description = "Skip adding the VM to a Content Library?"
    default = false
}

variable "vm-os-type" {
  type = string
  description = "The operating system type"
}

variable "vm_name" {
  type = string
  default = ""
  description = "The name of the Template to build"
}

variable "vm-firmware" {
  type = string
  default = "bios"
  description = "Firmware type BIOS/UEFI"
}

variable "vm-cpu-num" {
  type = number
  default = 2
  description = "The the number of vCPUs for the Template"
}

variable "vm-cpu-hotplug" {
  type = bool
  default = true
  description = "Is CPU HotPlug to be enabled? (true/false)"
}

variable "vm-mem-size" {
  type = number
  default = 4096
  description = "How much memory (GB) to assign to the Template?"
}

variable "vm-mem-hotplug" {
  type = bool
  default = true
  description = "Is Memory HotPlug to be enabled? (true/false)"
}

variable "vm-network-card" {
  type = string
  default = "e1000e"
  description = "Model of network card (e1000/e1000e/vmxnet3)"
}

variable "vm-disk-controller" {
  type = list(string)
  default = ["scsi"]
  description = "Model of Disk controller to use for OS disk"
}

variable "vm-disk-size" {
  type = number
  default = 40960
  description = "How large should the OS disk be sized (GB)?"
}

variable "vm-disk-thin" {
  type = bool
  default = true
  description = "Should the OS disk be thin-provisioned? (true/false)"
}

variable "vm-nested-hv" {
  type = bool
  default = false
  description = "Should nested virtualization (VT-X) be enabled? (true/false)"
}

variable "vm-video-ram" {
  type = number
  default = 16384
  description = "Amount of memory to use for video?"
}

variable "boot_command" {
  type = list(string)
  default = []
  description = "The boot command to use for the guest OS"
}

variable "admin_username" {
  type = string
  default = "root"
  sensitive = false
  description = "Admin username used to login"
}

variable "admin_password" {
  type = string
  sensitive = true
  description = "What is the password of the Administrative user?"
}

variable "guest_username" {
  type = string
  default = "Administrator"
  sensitive = false
  description = "Guest username used to login"
}

variable "guest_password" {
  type = string
  sensitive = true
  description = "What is the password of the guest user?"
}

variable "guest_language" {
  type = string
  default = "en_US"
  description = "What is the language of the Guest OS?"
}

variable "guest_timezone" {
  type = string
  default = "UTC"
  description = "What is the timezone of the Guest OS?"

}

variable "guest_keyboard" {
  type = string
  default = "en_US"
  description = "What is the keyboard layout of the Guest OS?"
}

variable "vm-version" {
  type = string
  default = 19          
  # 7.0u2
  description = "What is the VMware hardware version for this VM?"
}

variable "iso_checksum" {
  type = string
  default = "none"
  description = "What is the checksum of the ISO file to use for installation?"
}

variable "iso_url" {
  type = string
  description = "What is the URL from which to download the ISO to use for installation? (This will then be cached in the datastore by packer)"
}

variable "floppy_files" {
  type = list(string)
  description = "A list of files that will be placed on initial floppy used during OS installation"
}

variable "cd_label" {
  type = string
  default = "none"
  description = "The label of the CD/DVD drive to use for installation"
}

variable "cd_files" {
  type = list(string)
  description = "A list of files that will be placed on initial cd used during OS installation"
}

variable "script_files_group_1" {
  type = list(string)
  default = []
  description = "A list of scripts that will be run on the VM"
}

variable "script_files_group_2" {
  type = list(string)
  default = []
  description = "A list of scripts that will be run on the VM"
}

variable "inline_cmds" {
  type = list(string)
  default = []
  description = "A list of commands that will be run on the VM"
}

variable "phase2_inline" {
  type = list(string)
  default = []
  description = "A list of commands that will be run on the VM during phase 2"
}

# Timeout Settings
variable "vm_ssh_timeout" {
    type = string
    description = "Set the timeout for the VM to obtain an SSH connection (e.g. '1h5m2s' or '2s')"
    default = "30m"
}
variable "vm_ssh_agent_auth" {
    type = bool
    description = "Enable SSH Agent Authentication?"
    default = false
}
variable "vm_ssh_handshake_attempts" {
    type = number
    description = "Set the number of SSH handshake attempts"
    default = 10
}
variable "vm_ip_timeout" {
    type = string
    description = "Set the timeout for the VM to obtain an IP address (e.g. '1h5m2s' or '2s')"
    default = "3h"
}
variable "vm_shutdown_timeout" {
    type = string
    description = "Set the timeout for the VM to shutdown after the shutdown command is issued (e.g. '1h5m2s' or '2s')"
    default = "3h"
}
variable "ovf_export_path" {
    type = string
    description = "Set the path to export the OVF file to (e.g. './exports')"
}
# Guest Meta Data
variable "guest_os_family" {
    type = string
    description = "The Guest OS Family (e.g. 'windows' or 'linux')"
    default = "windows"
}
variable "guest_os_vendor" {
    type = string
    description = "The Guest OS Vendor (e.g. 'Microsoft' or 'RedHat')"
    default = "Microsoft"
}
variable "guest_os_version" {
    type = string
    description = "The Guest OS Version (e.g. '2019' or '7.9')"
    default = "2019"
}
variable "guest_os_type" {
    type = string
    description = "The Guest OS Type (e.g. 'Server' or 'Desktop')"
    default = "Server"
}
variable "guest_os_edition" {
    type = string
    description = "The Guest OS Edition (e.g. 'Standard' or 'Datacenter')"
    default = "Datacenter"
}
variable "guest_os_architecture" {
    type = string
    description = "The Guest OS Architecture (e.g. 'x86_64' or 'x86')"
    default = "x86_64"
}

# Git Hub Credentials
variable "github_token" {
    type = string
    description = "The GitHub Personal Access Token"
    default = ""
    sensitive = true
}
variable "github_username" {
    type = string
    description = "The GitHub Username"
    default = ""
}
# Used for RHN registration
variable "guest_redhat_user" {
  type = string
  description = "The Red Hat Network Username"
  default = ""
}
variable "guest_redhat_password" {
  type = string
  description = "The Red Hat Network Password"
  sensitive = true
  default = ""
}