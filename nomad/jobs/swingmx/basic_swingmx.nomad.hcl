job "swingmusic" {
  datacenters = ["homelab"]

  group "swingmusic" {

    network {
      mode = "bridge"
      port "http" {
        to = 1970
      }
    }
  }
  task "swingmusic" {
    driver = "docker"

    config {
      image = "ghcr.io/swingmx/swingmusic:latest"
      ports = ["http"]
    }


    resources {
      cpu    = 2000
      memory = 2048
    }
  }
}
