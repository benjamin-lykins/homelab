locals {
  client_ip_addresses = {
    "mf1" = "192.168.39.120/24"
    "mf2" = "192.168.39.121/24"
    "mf3" = "192.168.39.122/24"
  }
}

resource "proxmox_virtual_environment_vm" "clients" {
  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  node_name = each.key
  name      = "client-${each.key}"
  tags      = ["terraform", "client"]

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
        address = lookup(local.client_ip_addresses, each.key, "192.168.39.120/24")
        gateway = "192.168.39.1"
      }
    }
  }
  clone {
    node_name = "mf2"
    vm_id     = 202
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
  depends_on = [
    proxmox_virtual_environment_vm.server
  ]
}