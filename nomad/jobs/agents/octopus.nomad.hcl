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
        DISABLE_DIND       = "Y"
        ServerApiKey       = "API-TNKPTOADYUQESPYKEPNZIBHI4JAYK6KQ"
        ServerUrl          = "https://lykins.octopus.app"
        ServerCommsAddress = "https://polling.lykins.octopus.app"
        TargetWorkerPool   = "nomad"
        Space              = "homelab"
      }
    }
  }
}