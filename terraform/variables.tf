variable "proxmox_username" {
  type        = string
  description = "The username to authenticate with the Proxmox API"
  sensitive   = true
}

variable "proxmox_password" {
  type        = string
  description = "The password to authenticate with the Proxmox API"
  sensitive   = true
}

variable "username" {
  type        = string
  description = "The username to create on the VMs"
  sensitive   = true
}

variable "password" {
  type        = string
  description = "The password to create on the VMs"
  sensitive   = true
}