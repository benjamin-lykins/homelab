job "swingmusic" {
  datacenters = ["homelab"]
  type        = "service"

  group "swingmusic" {
    count = 1

    network {
      port "http" {
        static = 1970
      }
    }

    task "swingmusic" {
      driver = "docker"

      config {
        image        = "ghcr.io/swingmx/swingmusic:latest"
        ports        = ["http"]
        network_mode = "host"

        volumes = [
          "/nfs/general:/music",
          "/nfs/general:/config"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name     = "swingmusic"
        port     = "http"
        provider = "nomad"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}