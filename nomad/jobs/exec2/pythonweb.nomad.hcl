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
        name     = "hashitalks2025"
        port     = "http"
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Example</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            background-color: #f0f0f0;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        pre {
            background-color: #282c34;
            color: #fff;
            padding: 20px;
            border-radius: 8px;
            font-size: 1.2em;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <div class="container">
        <pre>
 _               _     _ _        _ _          ___   ___ ___  _____ 
| |             | |   (_) |      | | |        |__ \ / _ \__ \| ____|
| |__   __ _ ___| |__  _| |_ __ _| | | _____     ) | | | | ) | |__  
| '_ \ / _` / __| '_ \| | __/ _` | | |/ / __|   / /| | | |/ /|___ \ 
| | | | (_| \__ \ | | | | || (_| | |   <\__ \  / /_| |_| / /_ ___) |
|_| |_|\__,_|___/_| |_|_|\__\__,_|_|_|\_\___/ |____|\___/____|____/ 
        </pre>
    </div>
</body>
</html>
EOH
      }
    }
  }
}