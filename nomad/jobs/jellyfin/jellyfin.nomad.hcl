job "jellyfin" {
  datacenters = ["homelab"]
  type        = "service"

  group "jellyfin" {
    count = 1
        
    volume "media" {
      type      = "host"
      read_only = true
      source    = "media"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 8096
      }
      port "https" {
        to = 8920 
      }
    }
    
service {
  name = "jellyfin"
  provider = "nomad"
  tags = [
    "traefik.enable=true",
    "traefik.http.routers.jellyfin.entrypoints=web",
    "traefik.http.routers.jellyfin.rule=Host(`jellyfin.lykins.local`)",
    "traefik.http.services.jellyfin.loadbalancer.server.port=${NOMAD_HOST_PORT_http}"
  ]
}
    task "jellyfin" {
      driver = "docker"
      
      volume_mount {
        volume      = "media"
        destination = "/media"
        read_only   = true
      }

      config {
        image = "jellyfin/jellyfin:latest"
        ports = ["http", "https"]
        volumes = [
          "/nfs/general/jellyfin/config:/config",
          "/nfs/general/jellyfin/cache:/cache",
        ]
      }

      resources {
        cpu    = 1000
        memory = 2048
      }
    }
  }
}