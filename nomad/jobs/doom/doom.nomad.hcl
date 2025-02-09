job "doom" {
  datacenters = ["dc1"]

  group "doom" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    task "doom" {
      driver = "docker"

      config {
        image = "callumhoughton22/doom-in-docker:0.1"
        ports = ["http"]
      }

      restart {
        attempts = 3
        interval = "5m"
        delay = "25s"
        mode = "delay"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}