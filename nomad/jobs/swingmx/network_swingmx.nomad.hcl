job "swingmusic" {
  datacenters = ["homelab"]

  group "swingmusic" {

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
      }


      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}