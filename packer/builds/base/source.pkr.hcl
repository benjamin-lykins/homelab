source "proxmox-iso" "this" {
  # Connection
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  insecure_skip_tls_verify = var.proxmox_insecure_skip_tls_verify
  node                     = var.proxmox_node

  # VM
  vm_name = var.proxmox_vm_name
  vm_id   = var.proxmox_vm_id

  # Template
  template_name        = var.proxmox_template
  template_description = var.proxmox_template_description

  # Hardware
  bios     = var.proxmox_bios
  cpu_type = var.proxmox_cpu_type
  cores    = var.proxmox_cpu_cores
  sockets  = var.proxmox_cpu_sockets
  memory   = var.proxmox_memory

  # Cloud-Init
  cloud_init              = var.proxmox_cloud_init
  cloud_init_storage_pool = var.proxmox_cloud_init_storage_pool

  # Boot ISO
  boot_iso {
    # iso_url           = var.proxmox_boot_iso.iso_url
    # iso_checksum      = var.proxmox_boot_iso.iso_checksum
    # iso_target_path   = var.proxmox_boot_iso.iso_target_path
    # iso_storage_pool  = var.proxmox_boot_iso.iso_storage_pool
    iso_file          = var.proxmox_boot_iso.iso_file
    unmount           = var.proxmox_boot_iso.unmount
    keep_cdrom_device = var.proxmox_boot_iso.keep_cdrom_device
  }

  # Disk
  dynamic "disks" {
    for_each = var.proxmox_disks
    content {
      type         = disks.value.type
      disk_size    = disks.value.disk_size
      storage_pool = disks.value.storage_pool
    }
  }

  # Network
  dynamic "network_adapters" {
    for_each = var.proxmox_networks
    content {
      bridge = network_adapters.value.bridge
    }
  }

  # Preseed
  http_content = {
    "/preseed.cfg" = templatefile("${path.cwd}/packer/shared/http/preseed.cfg", {
      "ssh_public_key" = var.proxmox_ssh_public_key
      "root_password"  = var.proxmox_root_password
      "user_name"      = var.proxmox_build_username
      "user_password"  = var.proxmox_build_password
    })

  }

  # Boot Command
  boot_command = var.proxmox_boot_command
  boot_wait    = var.proxmox_boot_wait

  # Communicator
  communicator = var.proxmox_communicator

  ## SSH
  ssh_username = var.proxmox_communicator == "ssh" ? var.proxmox_ssh_username : null
  ssh_password = var.proxmox_communicator == "ssh" ? var.proxmox_ssh_password : null
  ssh_timeout  = var.proxmox_communicator == "ssh" ? var.proxmox_ssh_timeout : null

  ## WinRM
  winrm_username = var.proxmox_communicator == "winrm" ? var.proxmox_winrm_username : null
  winrm_password = var.proxmox_communicator == "winrm" ? var.proxmox_winrm_password : null
  winrm_timeout  = var.proxmox_communicator == "winrm" ? var.proxmox_winrm_timeout : null
}