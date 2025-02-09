job "gitea" {
  datacenters = ["homelab"]

  group "gitea" {
    network {
      mode = "bridge"

      port "http" {
        to = 3000
        static = 3000
      }

      port "ssh" {
        to = 22
        static = 222
      }
    }

        task "python" {
      driver = "exec2"

      config {
        command = "python3"
        args    = ["-m", "http.server", "${NOMAD_PORT_http}", "--directory", "${NOMAD_TASK_DIR}"]
        unveil  = ["r:/etc/mime.types"]
      }
      
      service {
      name = "hashitalks2025"
      port = "http"
      provider = "nomad"

      check {
        type     = "http"
        path     = "/hashitalks2025.html"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.exec2.rule=Path(`/hashitalks2025.html`)",
      ]
    }

    task "server" {
      driver = "docker"

      config {
        image = "docker.io/gitea/gitea:1.23.1"
        ports = ["http", "ssh"]

        volumes = [
          "local/gitea:/data",
          "/etc/timezone:/etc/timezone:ro",
          "/etc/localtime:/etc/localtime:ro"
        ]
      }

      env {
        USER_UID = "1000"
        USER_GID = "1000"
      }

      restart {
        attempts = 3
        interval = "5m"
        delay = "10s"
        mode = "fail"
      }
    }
  }
}
