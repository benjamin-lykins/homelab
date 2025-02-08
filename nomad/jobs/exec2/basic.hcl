job "http" {
  group "web" {
    network {
      port "http" {
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

  template {
        destination = "local/hashitalks2025.html"
        data        = <<EOH
<!doctype html>
<html>
  <title>example</title>
  <body><p>Hello, user!</p></body>
</html>
EOH
      }
    }
  }
}