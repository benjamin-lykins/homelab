job "octopus_tentacle" {
  datacenters = ["homelab"]

  group "tentacle" {
    count = 1

    task "octopus_tentacle" {
      driver = "docker"

      config {
        image = "octopusdeploy/tentacle"
      }

      env = {
        ACCEPT_EULA        = "Y"
        ServerUrl          = "https://lykins.octopus.app"
        ServerCommsAddress = "https://polling.lykins.octopus.app"
        TargetWorkerPool   = "nomad"
        Space              = "homelab"
      }

      template {
        data        = <<EOH
ServerApiKey="{{ with nomadVar "nomad/jobs/" }}{{ .OCTOPUS_TOKEN }}{{ end }}"
EOH
        destination = "secrets/file.env"
        env         = true
      }
    }
  }
}