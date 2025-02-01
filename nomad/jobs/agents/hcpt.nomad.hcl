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
        TFC_AGENT_TOKEN  = "zURzPaOUpCHP3w.atlasv1.yyEWT7x7FzEhSGzH1pj79gleqgIFpliBp84oBaynuncUY08JhXMVWE8EJDgq5dfLu7M"
      }

      resources {
        memory = 256
      }
    }
  }
}