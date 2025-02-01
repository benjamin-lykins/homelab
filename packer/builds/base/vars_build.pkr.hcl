variable "scripts" {
  description = "Scripts"
  type = map(object({
    path = string
  }))
  default = {
    "0" = {
      path = "packer/shared/scripts/linux/debian/client.sh"
    }
    "1" = {
      path = "packer/shared/scripts/linux/debian/deprovision.sh"
    }
  }
}

variable "files" {
  description = "files"
  type = map(object({
    source      = string
    destination = string
  }))
  default = {
    "0" = {
      source      = "packer/shared/files/nomad/client/client.nomad.hcl"
      destination = "/etc/nomad.d/client.nomad.hcl"
    }
    "1" = {
      source      = "packer/shared/files/nomad/client/nomad.service"
      destination = "/lib/systemd/system/nomad.service"
    }
  }
}