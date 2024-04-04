###############################################################################
# Name:             variable_defs.pkr.hcl
# Description:      Variable Definitions
# Author:           Daniel Whicker
# Date:             2021-05-29
###############################################################################

variable "template" {
  type    = string
  default = ""
}

variable "http_directory" {
  type    = string
  default = ""
}

variable "vsphere_server" {
  type      = string
  sensitive = false
  default   = env("VSPHERE_SERVER")
}

variable "vsphere_username" {
  type      = string
  sensitive = false
  default   = env("VSPHERE_USERNAME")
}

variable "vsphere_password" {
  type      = string
  sensitive = true
  default   = env("VSPHERE_PASSWORD")
}

variable "vsphere_datacenter" {
  type      = string
  sensitive = false
  default   = env("VSPHERE_DATACENTER")
}

variable "vsphere_cluster" {
  type        = string
  description = "The VMware Cluster name to build the Template"
  sensitive   = false
  default     = env("VSPHERE_CLUSTER")
}

variable "vsphere_network" {
  type        = string
  description = "The VMware PortGroup name to build the Template"
  sensitive   = false
  default     = env("VSPHERE_NETWORK")
}

variable "vsphere_datastore" {
  type        = string
  description = "The VMware Datastore name to place the Template"
  sensitive   = false
  default     = env("VSPHERE_DATASTORE")
}

variable "vsphere_folder" {
  type        = string
  description = "The VMware Folder Name name to place the Template"
  sensitive   = false
  default     = env("VSPHERE_FOLDER")
}

variable "vsphere_insecure_connection" {
  type        = bool
  default     = "true"
  description = "Should the connection to vCenter be insecure? (true/false)"
  sensitive   = false
}

# vSphere Content Library and Template Configuration
variable "vsphere_convert_template" {
  type        = bool
  description = "Convert the VM to a template?"
  default     = false
}
variable "vsphere_content_library" {
  type        = string
  description = "Name of the vSphere Content Library to export the VM to"
  default     = null
  # default     = env("VSPHERE_CONTENT_LIBRARY")
}
variable "vsphere_content_library_ovf" {
  type        = bool
  description = "Export to Content Library as an OVF file?"
  default     = false
  # default     = env("VSPHERE_CONTENT_LIBRARY_OVF")
}
variable "vsphere_content_library_destroy" {
  type        = bool
  description = "Delete the VM after successfully exporting to a Content Library?"
  default     = false
  # default     = env("VSPHERE_CONTENT_LIBRARY_DESTROY")
}
variable "vsphere_content_library_name" {
  type        = string
  description = "Name of the VM in the Content Library"
  default     = null
  # default     = env("VSPHERE_CONTENT_LIBRARY_NAME")
}
variable "vsphere_content_library_skip" {
  type        = bool
  description = "Skip adding the VM to a Content Library?"
  default     = false
}

variable "vm_os_type" {
  type        = string
  description = "The operating system type"
}

variable "vm_name" {
  type        = string
  default     = ""
  description = "The name of the Template to build"
}

variable "vm_firmware" {
  type        = string
  default     = "bios"
  description = "Firmware type BIOS/UEFI"
}

variable "vm_cpu_num" {
  type        = number
  default     = 2
  description = "The the number of vCPUs for the Template"
}

variable "vm_cpu_hotplug" {
  type        = bool
  default     = true
  description = "Is CPU HotPlug to be enabled? (true/false)"
}

variable "vm_mem_size" {
  type        = number
  default     = 4096
  description = "How much memory (GB) to assign to the Template?"
}

variable "vm_mem_hotplug" {
  type        = bool
  default     = true
  description = "Is Memory HotPlug to be enabled? (true/false)"
}

variable "vm_network_card" {
  type        = string
  default     = "e1000e"
  description = "Model of network card (e1000/e1000e/vmxnet3)"
}

variable "vm_disk_controller" {
  type        = list(string)
  default     = ["scsi"]
  description = "Model of Disk controller to use for OS disk"
}

variable "vm_disk_size" {
  type        = number
  default     = 40960
  description = "How large should the OS disk be sized (GB)?"
}

variable "vm_disk_thin" {
  type        = bool
  default     = true
  description = "Should the OS disk be thin-provisioned? (true/false)"
}

variable "vm_nested_hv" {
  type        = bool
  default     = false
  description = "Should nested virtualization (VT-X) be enabled? (true/false)"
}

variable "vm_video_ram" {
  type        = number
  default     = 16384
  description = "Amount of memory to use for video?"
}

variable "boot_wait" {
  type        = string
  default     = "3s"
  description = "How long to wait for the VM to boot?"
}

variable "boot_command" {
  type        = list(string)
  default     = []
  description = "The boot command to use for the guest OS"
}

variable "admin_username" {
  type        = string
  sensitive   = false
  description = "Admin username used to login"
  default     = env("ADMIN_USERNAME")
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "What is the password of the Administrative user?"
  default     = env("ADMIN_PASSWORD")
}

variable "guest_username" {
  type        = string
  sensitive   = false
  description = "Guest username used to login"
  default     = env("GUEST_USERNAME")
}

variable "guest_password" {
  type        = string
  sensitive   = true
  description = "What is the password of the guest user?"
  default     = env("GUEST_PASSWORD")
}

variable "guest_language" {
  type        = string
  default     = "en_US"
  description = "What is the language of the Guest OS?"
}

variable "guest_timezone" {
  type        = string
  default     = "UTC"
  description = "What is the timezone of the Guest OS?"

}

variable "guest_keyboard" {
  type        = string
  default     = "en_US"
  description = "What is the keyboard layout of the Guest OS?"
}

variable "vm_version" {
  type    = string
  default = 19
  # 7.0u2
  description = "What is the VMware hardware version for this VM?"
}

variable "iso_checksum" {
  type        = string
  default     = "none"
  description = "What is the checksum of the ISO file to use for installation?"
}

variable "iso_url" {
  type        = string
  description = "What is the URL from which to download the ISO to use for installation? (This will then be cached in the datastore by packer)"
}

variable "floppy_files" {
  type        = list(string)
  description = "A list of files that will be placed on initial floppy used during OS installation"
}

variable "cd_label" {
  type        = string
  default     = "none"
  description = "The label of the CD/DVD drive to use for installation"
}

variable "cd_files" {
  type        = list(string)
  description = "A list of files that will be placed on initial cd used during OS installation"
}

variable "script_files_group_1" {
  type        = list(string)
  default     = []
  description = "A list of scripts that will be run on the VM"
}

variable "script_files_group_2" {
  type        = list(string)
  default     = []
  description = "A list of scripts that will be run on the VM"
}

variable "inline_commands" {
  type        = list(string)
  default     = []
  description = "A list of commands that will be run on the VM"
}

variable "remote_communicator" {
  type        = string
  default     = "ssh"
  description = "The remote communicator to use for the VM"
}
variable "vm_ssh_timeout" {
  type        = string
  description = "Set the timeout for the VM to obtain an SSH connection (e.g. '1h5m2s' or '2s')"
  default     = "30m"
}
variable "vm_ssh_agent_auth" {
  type        = bool
  description = "Enable SSH Agent Authentication?"
  default     = false
}
variable "vm_ssh_handshake_attempts" {
  type        = number
  description = "Set the number of SSH handshake attempts"
  default     = 10
}
variable "vm_ip_timeout" {
  type        = string
  description = "Set the timeout for the VM to obtain an IP address (e.g. '1h5m2s' or '2s')"
  default     = "3h"
}
variable "vm_shutdown_timeout" {
  type        = string
  description = "Set the timeout for the VM to shutdown after the shutdown command is issued (e.g. '1h5m2s' or '2s')"
  default     = "3h"
}
variable "ovf_export_path" {
  type        = string
  description = "Set the path to export the OVF file to (e.g. './exports')"
  default     = null
}
# Guest Meta Data
variable "guest_os_family" {
  type        = string
  description = "The Guest OS Family (e.g. 'windows' or 'linux')"
  default     = "windows"
}
variable "guest_os_vendor" {
  type        = string
  description = "The Guest OS Vendor (e.g. 'Microsoft' or 'RedHat')"
  default     = "Microsoft"
}
variable "guest_os_version" {
  type        = string
  description = "The Guest OS Version (e.g. '2019' or '7.9')"
  default     = "2019"
}
variable "guest_os_type" {
  type        = string
  description = "The Guest OS Type (e.g. 'Server' or 'Desktop')"
  default     = "Server"
}
variable "guest_os_edition" {
  type        = string
  description = "The Guest OS Edition (e.g. 'Standard' or 'Datacenter')"
  default     = "Datacenter"
}
variable "guest_os_architecture" {
  type        = string
  description = "The Guest OS Architecture (e.g. 'x86_64' or 'x86')"
  default     = "x86_64"
}

# Git Hub Credentials
variable "github_token" {
  type        = string
  description = "The GitHub Personal Access Token"
  default     = ""
  sensitive   = true
}
variable "github_username" {
  type        = string
  description = "The GitHub Username"
  default     = ""
}
# Used for RHN registration
variable "redhat_username" {
  type        = string
  description = "The Red Hat Network Username"
  default     = env("REDHAT_USERNAME")
}
variable "redhat_password" {
  type        = string
  description = "The Red Hat Network Password"
  sensitive   = true
  default     = env("REDHAT_PASSWORD")
}
variable "redhat_registration_command" {
  type        = string
  description = "The Red Hat Registration Command"
  default     = env("REDHAT_REGISTRATION_COMMAND")
}

# Windows Installer Variables
variable "windows_image_index" {
  type        = number
  description = "The Windows Image Index"
  default     = 1
}
# Azure Variables
variable "arm_client_id" {
  type        = string
  description = "The Azure Client ID"
  default     = env("ARM_CLIENT_ID")
  sensitive   = true
}
variable "arm_client_secret" {
  type        = string
  description = "The Azure Client Secret"
  default     = env("ARM_CLIENT_SECRET")
  sensitive   = true
}
variable "arm_tenant_id" {
  type        = string
  description = "The Azure Tenant ID"
  default     = env("ARM_TENANT_ID")
  sensitive   = true
}
variable "arm_subscription_id" {
  type        = string
  description = "The Azure Subscription ID"
  default     = env("ARM_SUBSCRIPTION_ID")
  sensitive   = true
}
variable "arm_resource_group" {
  type        = string
  description = "The Azure Resource Group"
  default     = env("ARM_RESOURCE_GROUP")
  sensitive   = false
}
variable "arm_image_publisher" {
  type        = string
  description = "The Azure Image Publisher"
  default     = env("ARM_IMAGE_PUBLISHER")
  sensitive   = false
}
variable "arm_image_offer" {
  type        = string
  description = "The Azure Image Offer"
  default     = env("ARM_IMAGE_OFFER")
  sensitive   = false
}
variable "arm_image_sku" {
  type        = string
  description = "The Azure Image SKU"
  default     = env("ARM_IMAGE_SKU")
  sensitive   = false
}
variable "arm_managed_image_name" {
  type        = string
  description = "The Azure Managed Image Name"
  default     = "PackerImage"
  sensitive   = false
}
variable "arm_image_version" {
  type        = string
  description = "The Azure Image Version"
  default     = "latest"
  sensitive   = false
}
variable "arm_vm_size" {
  type        = string
  description = "The Azure VM Size"
  default     = "Standard_DS2_v2"
  sensitive   = false
}
variable "arm_location" {
  type        = string
  description = "The Azure Location"
  default     = env("ARM_LOCATION")
  sensitive   = false
}
variable "hcp_bucket_name" {
  type        = string
  description = "The HCP Bucket Name"
  default     = ""
  sensitive   = false
}
variable "user_data" {
  type        = string
  description = "The cloud-init user data"
  default     = ""
  sensitive   = false
}
