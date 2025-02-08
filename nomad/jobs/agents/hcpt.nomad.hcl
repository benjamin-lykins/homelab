job "tfc-agent" {
  datacenters = ["homelab"]
  type        = "service"

  group "tfc-agent" {
    count = 1
    task "tfc-agent" {
      driver = "docker"

      config {
        image = "hashicorp/tfc-agent"
      }

      env {
        TFC_AGENT_SINGLE = "true"
        TFC_AGENT_NAME   = "${NOMAD_TASK_NAME}-${NOMAD_ALLOC_ID}"
      }
            template {
        data        = <<EOH
TFC_AGENT_TOKEN="{{ with nomadVar "nomad/jobs/" }}{{ .TFC_AGENT_TOKEN }}{{ end }}"
EOH
        destination = "secrets/file.env"
        env         = true
      }

      resources {
        memory = 256
      }
    }
  }
}