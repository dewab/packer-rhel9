variable "vsphere_server" {
  description = "vSphere server"
  type        = string
}

variable "vsphere_usernamename" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere data center"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere datastore"
  type        = string
}

variable "vsphere_network" {
  description = "vSphere network name"
  type        = string
}

variable "vsphere_folder" {
  description = "vSphere folder name"
  type        = string
}

variable "redhat_username" {
  description = "Red Hat Cloud username"
  type        = string
}

variable "redhat_password" {
  description = "Red Hat Cloud password"
  type        = string
  sensitive   = true
}

variable "guest_username" {
  description = "Guest OS username"
  type        = string
}

variable "guest_password" {
  description = "Guest OS password"
  type        = string
  sensitive   = true
}

variable "redhat_registration_command" {
  description = "Red Hat registration command"
  type        = string
}
