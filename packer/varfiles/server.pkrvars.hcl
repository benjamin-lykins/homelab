proxmox_vm_name  = "server-base"
proxmox_template = "server-base"
proxmox_vm_id    = 201
proxmox_node     = "mf3"

proxmox_disks = {
  "0" = {
    disk_size    = "40G"
    storage_pool = "pool0"
    type         = "scsi"
  }
}

scripts = {
  "0" = {
    path = "packer/shared/scripts/linux/debian/base.sh"
  }
  "1" = {
    path = "packer/shared/scripts/linux/debian/server.sh"
  }
  "2" = {
    path = "packer/shared/scripts/linux/debian/deprovision.sh"
  }
}

files = {
  "0" = {
    source      = "packer/shared/files/nomad/server/server.nomad.hcl"
    destination = "/tmp/nomad.hcl"
  }
  "1" = {
    source      = "packer/shared/files/nomad/server/nomad.service"
    destination = "/tmp/nomad.service"
  }
}