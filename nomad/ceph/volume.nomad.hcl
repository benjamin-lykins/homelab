id           = "ceph"
name         = "ceph"
type         = "csi"
plugin_id    = "ceph-csi"
capacity_max = "200G"
capacity_min = "100G"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

secrets {
  userID  = "admin"
  userKey = "AQAfWCJni+efOhAAF9r2h22cd5Ib8aFMewmP2w=="
}

parameters {
  clusterID     = "557db982-e3ca-494b-9a2a-44ad63aa69bd"
  pool          = "pool0"
  imageFeatures = "layering"
  mkfsOptions   = "-t ext4"
}