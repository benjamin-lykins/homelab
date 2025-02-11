proxmox_vm_name  = "hashitalks"
proxmox_template = "hashitalks"
proxmox_vm_id    = 300
proxmox_node     = "mf1"

proxmox_disks = {
  "0" = {
    disk_size    = "10G"
    storage_pool = "pool0"
    type         = "scsi"
  }
}

scripts = {
  "0" = {
    path = "packer/shared/scripts/linux/debian/base.sh"
  }
  "1" = {
    path = "packer/shared/scripts/linux/debian/deprovision.sh"
  }
}