job "swingmusic" {
  datacenters = ["dc1"]

  group "swingmusic" {
    
    network {
    mode = "host"

    port "http" {
      to = 1970
    }
    }
    service {
    name = "swingmusic"
    provider = "nomad"
    port = "http"
      }
    task "swingmusic" {
      driver = "docker"

      config {
        image = "ghcr.io/swingmx/swingmusic:latest"
        ports = ["http"]
        
        volumes = [
          "local/music:/music",
          "local/config:/config"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
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
