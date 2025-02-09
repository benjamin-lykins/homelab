job "ceph-csi-plugin-controller" {
  datacenters = ["homelab"]
  group "controller" {
    service {
      provider = "nomad"
      name     = "ceph-csi-controller"
      port     = "metrics"
      tags     = ["prometheus"]
    }
    network {
      port "metrics" {}
    }
    task "ceph-controller" {
      template {
        data        = <<EOF
[{
    "clusterID": "557db982-e3ca-494b-9a2a-44ad63aa69bd",
    "monitors": [
        "192.168.39.10",
        "192.168.39.11",
        "192.168.39.12"
    ]
}]
EOF
        destination = "local/config.json"
        change_mode = "restart"
      }
      driver = "docker"
      config {
        image = "quay.io/cephcsi/cephcsi:v3.3.1"
        volumes = [
          "./local/config.json:/etc/ceph-csi-config/config.json"
        ]
        mounts = [
          {
            type     = "tmpfs"
            target   = "/tmp/csi/keys"
            readonly = false
            tmpfs_options = {
              size = 1000000
            }
          }
        ]
        args = [
          "--type=rbd",
          "--controllerserver=true",
          "--drivername=rbd.csi.ceph.com",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${node.unique.name}",
          "--instanceid=${node.unique.name}-controller",
          "--pidlimit=-1",
          "--logtostderr=true",
          "--v=5",
          "--metricsport=$${NOMAD_PORT_metrics}"
        ]
      }
      resources {
        cpu    = 500
        memory = 256
      }
      csi_plugin {
        id        = "ceph-csi"
        type      = "controller"
        mount_dir = "/csi"
      }
    }
  }
}