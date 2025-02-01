vm_name          = "client-base"
proxmox_template = "client-base"
vm_id            = 202

proxmox_disks = {
  "0" = {
    disk_size    = "40G"
    storage_pool = "pool0"
    type         = "scsi"
  }
}

scripts = {
  "0" = {
    path = "packer/shared/scripts/linux/debian/client.sh"
  }
  "1" = {
    path = "packer/shared/scripts/linux/debian/deprovision.sh"
  }
}

files = {
  "0" = {
    source      = "packer/shared/files/nomad/client/client.nomad.hcl"
    destination = "/tmp/client.nomad.hcl"
  }
  "1" = {
    source      = "packer/shared/files/nomad/client/nomad.service"
    destination = "/tmp/nomad.service"
  }
}