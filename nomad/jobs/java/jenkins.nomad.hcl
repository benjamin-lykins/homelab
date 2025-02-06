job "jenkins" {
  type        = "service"
  datacenters = ["homelab"]
  group "jenkins" {
    count = 1

    ephemeral_disk {
      migrate = true
      size    = "500"
      sticky  = true
    }

    network {
      port "http" {
      }
    }
    task "jenkins" {
      env {
        JENKINS_HOME = "/alloc/data"
      }
      driver = "java"
      config {
        jar_path    = "local/jenkins.war"
        jvm_options = ["-Xmx768m", "-Xms384m"]
        args        = ["--httpPort=${NOMAD_PORT_http}"]
      }
      artifact {
        source = "https://get.jenkins.io/war-stable/2.479.3/jenkins.war"

        options {
          checksum = "sha256:304c8592860d5b03dec27c96b5e89ec58fc744f78161c53f7a344a0bf7ce9203"
        }
      }

      resources {
        cpu    = 1000
        memory = 1024
      }

      service {
        port     = "http"
        provider = "nomad"
        name     = "jenkins"
        check {
          type     = "http"
          path     = "/login"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}