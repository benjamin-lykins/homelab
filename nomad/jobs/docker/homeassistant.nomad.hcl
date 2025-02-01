job "homeassistant" {
  datacenters = ["homelab"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = false
    canary            = 0
  }

  migrate {
    max_parallel     = 1
    health_check     = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "homeassistant" {
    count = 1

    network {
      port "homeassistant" {
        static = 8123
      }
      mode = "host"
    }

    service {
      name     = "homeassistant"
      port     = "homeassistant"
      provider = "nomad"


      check {
        type     = "http"
        path     = "/"
        port     = "homeassistant"
        interval = "30s"
        timeout  = "20s"

        check_restart {
          limit = 3
          grace = "2m"
        }
      }

    }

    restart {
      attempts = 5
      interval = "5m"
      delay    = "30s"
      mode     = "delay"
    }

    task "homeassistant" {
      driver = "docker"

      config {
        image          = "homeassistant/home-assistant:latest"
        network_mode   = "host"
        ports          = ["homeassistant"]
        privileged     = true
        auth_soft_fail = true
        volumes = [
          "/nfs/general:/config",
          "run/dbus:/run/dbus:ro" # Required for bluetooth compatibility
        ]
      }

      resources {
        cores  = 2
        memory = 1024
      }

      env {
        TZ = "America/Detroit"
      }
    }
  }
}