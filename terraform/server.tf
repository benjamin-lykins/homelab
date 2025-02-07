resource "proxmox_virtual_environment_vm" "server" {
  node_name = "mf2"
  name      = "server"
  tags      = ["terraform", "server"]

  memory {
    dedicated = 4096
  }

  initialization {
    user_account {
      username = var.username
      password = var.password
    }
    ip_config {
      ipv4 {
        address = "192.168.39.100/24"
        gateway = "192.168.39.1"
      }
    }
  }
  clone {
    node_name = "mf3"
    vm_id     = 201
    full      = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type     = "ssh"
      host     = "192.168.39.100"
      user     = var.username
      password = var.password
    }
  }

  lifecycle {
    ignore_changes = [
      network_device, vga
    ]
  }
}