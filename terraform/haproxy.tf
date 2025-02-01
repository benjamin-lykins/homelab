resource "proxmox_virtual_environment_vm" "haproxy" {
  node_name = "mf3"
  name      = "haproxy"
  tags      = ["terraform", "loadbalancer"]

  memory {
    dedicated = 2048
  }

  initialization {
    user_account {
      username = var.username
      password = var.password
    }
    ip_config {
      ipv4 {
        address = "192.168.39.80/24"
        gateway = "192.168.39.1"
      }
    }
  }
  disk {
    interface = "scsi0"
    size      = 40
    replicate = false
  }

  clone {
    node_name = "mf1"
    vm_id     = 200
    full      = true
  }

   lifecycle {
    ignore_changes = [
      network_device, vga
    ]
  }
}