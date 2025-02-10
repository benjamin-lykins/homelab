job "swingmusic" {
  datacenters = ["homelab"]

  group "swingmusic" {

    volume "ceph" {
      type            = "csi"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
      read_only       = false
      source          = "ceph"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 1970
      }
    }
    service {
      name     = "swingmusic"
      provider = "nomad"
      port     = "http"

      check {
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.swingmx.entrypoints=web",
        "traefik.http.routers.swingmx.rule=Host(`swingmx.lykins.local`)",
        "traefik.http.services.swingmx.loadbalancer.server.port=${NOMAD_HOST_PORT_http}"
      ]
    }
    task "swingmusic" {
      driver = "docker"

      config {
        image = "ghcr.io/swingmx/swingmusic:latest"
        ports = ["http"]
        volumes = [
        "/nfs/general/media:/copy"
        ]
      }

      volume_mount {
        volume      = "ceph"
        destination = "/music"
        read_only   = false
      }

      volume_mount {
        volume      = "ceph"
        destination = "/config"
        read_only   = false
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
      restart {
        attempts = 0
        interval = "30m"
        delay    = "15s"
        mode     = "delay"
      }
    }
  }
}
