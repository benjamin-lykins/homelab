job "jellyfin" {
  datacenters = ["homelab"]
  type        = "service"

  group "jellyfin" {
    count = 1

    network {
      mode = "bridge" # Use bridge mode instead of host
      port "http" {
        to = 8096 # Map container's port 8096
      }
      port "https" {
        to = 8920 # Map container's port 8920
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

      config {
        image = "jellyfin/jellyfin:latest"
        ports = ["http", "https"]
        volumes = [
          "/nfs/general/jellyfin/config:/config",
          "/nfs/general/jellyfin/cache:/cache",
          "/nfs/general/media:/media"
        ]
      }

      resources {
        cpu    = 1000
        memory = 2048
      }
    }
  }
}