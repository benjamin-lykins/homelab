



variable "proxmox_url" {
  description = "Proxmox URL"
  type        = string
  default     = env("PROXMOX_URL") #"https://192.168.39.10:8006/api2/json"
}

variable "proxmox_username" {
  description = "Proxmox Username"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox Password"
  type        = string
  sensitive   = true
  default     = env("PROXMOX_PASSWORD")
}

variable "proxmox_insecure_skip_tls_verify" {
  description = "Proxmox Insecure Skip TLS Verify"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox Node"
  type        = string
  default     = "mf1"
}

variable "proxmox_vm_name" {
  description = "VM Name"
  type        = string
  default     = "packer-base"
}

variable "proxmox_vm_id" {
  description = "VM ID"
  type        = number
  default     = 100
}

variable "proxmox_template" {
  description = "Proxmox Template"
  type        = string
  default     = "packer-base"
}

variable "proxmox_template_description" {
  description = "Proxmox Template Description"
  type        = string
  default     = "Packer VM"
}

variable "proxmox_bios" {
  description = "Proxmox BIOS"
  type        = string
  default     = "seabios"
}

variable "proxmox_cpu_type" {
  description = "Proxmox CPU Type"
  type        = string
  default     = "host"
}

variable "proxmox_cpu_cores" {
  description = "Proxmox CPU Cores"
  type        = number
  default     = 1
}

variable "proxmox_cpu_sockets" {
  description = "Proxmox CPU Sockets"
  type        = number
  default     = 2
}

variable "proxmox_memory" {
  description = "Proxmox Memory"
  type        = number
  default     = 4096
}

variable "proxmox_boot_iso" {
  description = "Proxmox ISO"
  type = object({
    iso_download_pve  = bool
    iso_url           = string
    iso_target_path   = string
    iso_checksum      = string
    iso_storage_pool  = string
    iso_file          = string
    unmount           = bool
    keep_cdrom_device = bool
  })
  default = {
    iso_download_pve  = false
    iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.8.0-amd64-netinst.iso"
    iso_target_path   = "debian-12.8.0-amd64-netinst.iso"
    iso_checksum      = "sha512:f4f7de1665cdcd00b2e526da6876f3e06a37da3549e9f880602f64407f602983a571c142eb0de0eacfc9c1d0f534e9339cdce04eb9daddc6ddfa8cf34853beed"
    iso_storage_pool  = "cephfs"
    iso_file          = "cephfs:iso/debian-12.8.0-amd64-netinst.iso"
    unmount           = true
    keep_cdrom_device = false
  }
}

variable "proxmox_cloud_init" {
  description = "Proxmox Cloud Init"
  type        = bool
  default     = true
}

variable "proxmox_cloud_init_storage_pool" {
  description = "Proxmox Cloud Init Storage Pool"
  type        = string
  default     = "pool0"
}

variable "proxmox_disks" {
  description = "Proxmox Disks"
  type = map(object({
    type         = string
    disk_size    = string
    storage_pool = string
  }))
  default = {
    0 = {
      type         = "scsi"
      disk_size    = "10G"
      storage_pool = "pool0"
    }
  }
}

variable "proxmox_networks" {
  description = "Proxmox Networks"
  type = map(object({
    bridge = string
  }))
  default = {
    0 = {
      bridge = "vmbr0"
    }
  }
}

variable "proxmox_boot_command" {
  description = "Proxmox Boot Command"
  type        = list(string)
  default     = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
}

variable "proxmox_boot_wait" {
  description = "Proxmox Boot Wait"
  type        = string
  default     = "15s"
}

variable "proxmox_root_username" {
  description = "Proxmox SSH Username"
  type        = string
  default     = "root"
}

variable "proxmox_root_password" {
  description = "Proxmox Root Password"
  type        = string
  sensitive   = true
  default     = env("PROXMOX_ROOT_PASSWORD")
}

variable "proxmox_build_username" {
  description = "Proxmox User Name, added onto the image."
  type        = string
  default     = "packer"
}

variable "proxmox_build_password" {
  description = "Proxmox User Password, added onto the image."
  type        = string
  sensitive   = true
  default     = env("PROXMOX_USER_PASSWORD")
}

variable "proxmox_communicator" {
  description = "Proxmox Communicator"
  type        = string
  default     = "ssh"
}

# variable "github_account" {
#   description = "GitHub Account, used to pull public ssh keys."
#   type        = string
#   default     = "benjamin-lykins"
# }

variable "proxmox_ssh_public_key" {
  description = "Proxmox SSH User Key"
  type        = string
  sensitive   = true
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3rD5lca16GXd1ej9xc05FE7tYwhCy5BUWiehExRv26HJl7/e+wqQpZJSzBXFUB6+60JnEOgUbaAFXubNOFLyTNHDqPioZHxLF/AhzDvBSfPiVoHQC9mlbNoxK4djb7QmFtNqGXr0wXCTm3S0+icISDjdsrcuIbKTlshoUuTQ+b+7CoujbMvH/I1Mf3TrM6u4ZOWVN+2i/qdsELDmC90GfJXyn8/ebsP7zd0HEA0/qVekB2pnPRNLJCsyo1VNH+f78u3S+hBvc76MTX/YiqKY2L5yqvTAqKMkluerxVlDNi31erp3ghQ+YqVRW37I9ge8lNb/XFI6ZC/zBpvaMM93gg2rhuRdG8zuw4CHbUYP3MNuePeV9vDZBFInnpvwedsrpBRi3vjdrwKYTvKL0QpTATYk+jUTpJxLANR8hzGB0rZzF2N4acHmxt7hRizj9aTvMgEUuusv3MVwfuz5X+y8TCqJsl9XdH/xdWDN8DPo19xPp94WiEQRKSly+CTPMnHE= benjamin.lykins@benjamin.lykins-KT2YYXQG9Y"
}

variable "proxmox_ssh_username" {
  description = "Proxmox SSH Username"
  type        = string
  default     = "root"
}

variable "proxmox_ssh_password" {
  description = "Proxmox SSH Password"
  type        = string
  sensitive   = true
  default     = env("PROXMOX_ROOT_PASSWORD")
}

variable "proxmox_ssh_timeout" {
  description = "Proxmox SSH Timeout"
  type        = string
  default     = "30m"
}

variable "proxmox_winrm_username" {
  description = "Proxmox WinRM Username"
  type        = string
  default     = "Administrator"
}

variable "proxmox_winrm_password" {
  description = "Proxmox WinRM Password"
  type        = string
  sensitive   = true
  default     = env("PROXMOX_WINRM_PASSWORD")
}

variable "proxmox_winrm_timeout" {
  description = "Proxmox WinRM Timeout"
  type        = string
  default     = "30m"
}
