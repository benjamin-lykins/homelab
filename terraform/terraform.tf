terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.69.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.39.10:8006/"
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}
