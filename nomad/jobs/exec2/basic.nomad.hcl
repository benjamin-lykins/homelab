job "http" {
  group "web" {
    network {
      mode = "host"
      port "http" {
        static = 8181
      }
    }

    task "python" {
      driver = "exec2"

      config {
        command = "python3"
        args    = ["-m", "http.server", "${NOMAD_PORT_http}", "--directory", "${NOMAD_TASK_DIR}"]
        unveil  = ["r:/etc/mime.types"]
      }

      template {
        destination = "local/index.html"
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