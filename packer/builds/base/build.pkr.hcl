

build {
  sources = ["source.proxmox-iso.this"]

  dynamic "provisioner" {
    for_each = var.files

    labels = ["file"]
    content {
      source      = provisioner.value.source
      destination = provisioner.value.destination
    }
  }

  dynamic "provisioner" {
    for_each = var.scripts

    labels = ["shell"]
    content {
      script = provisioner.value.path
    }
  }


}