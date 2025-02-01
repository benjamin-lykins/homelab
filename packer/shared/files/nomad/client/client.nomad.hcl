# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

# Full configuration options can be found at https://developer.hashicorp.com/nomad/docs/configuration

datacenter = "homelab"
data_dir   = "/opt/nomad/data"
bind_addr  = "0.0.0.0"

client {
  enabled = true
  servers = ["192.168.39.100"]

  host_volume "homelab" {
    path      = "/nfs/general"
    read_only = false
  }
}

plugin "docker" {
  allow_privileged = true
  volumes {
    enabled = true
  }
}

plugin "docker" {
  config {
    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]

    gc {
      image       = true
      image_delay = "3m"
      container   = true

      dangling_containers {
        enabled        = true
        dry_run        = false
        period         = "5m"
        creation_grace = "5m"
      }
    }

    volumes {
      enabled      = true
      selinuxlabel = "z"
    }

    allow_privileged = true
    allow_caps       = ["chown", "net_raw"]
  }
}

# https://developer.hashicorp.com/nomad/plugins/drivers/podman
plugin "nomad-driver-podman" {
  config {
    volumes {
      enabled      = true
      selinuxlabel = "z"
    }
  }
}

# https://developer.hashicorp.com/nomad/plugins/drivers/exec2
plugin "nomad-driver-exec2" {
  config {
    unveil_defaults = true
    unveil_paths    = []
    unveil_by_task  = true
  }
}