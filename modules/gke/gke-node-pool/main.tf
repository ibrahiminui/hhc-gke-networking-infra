terraform {
  backend "gcs" {
  }
}

resource "google_container_node_pool" "node_pool" {
  provider = google-beta
  count    = length(var.node_pool)
  name     = format("%s%s", lookup(var.node_pool[count.index], "name", var.default_node_pool["name"]), var.suffix)
  location = var.region
  project  = var.project
  cluster  = element(var.cluster_name, count.index)
  version  = lookup(var.node_pool[count.index], "version", var.default_node_pool["version"])

  management {
    auto_repair  = lookup(var.node_pool[count.index], "auto_repair", var.default_node_pool["auto_repair"])
    auto_upgrade = lookup(var.node_pool[count.index], "auto_upgrade", var.default_node_pool["auto_upgrade"])
  }

  autoscaling {
    min_node_count = lookup(var.node_pool[count.index], "min_node_count", var.default_node_pool["min_node_count"])
    max_node_count = lookup(var.node_pool[count.index], "max_node_count", var.default_node_pool["max_node_count"])
  }
  initial_node_count = lookup(var.node_pool[count.index], "initial_node_count", var.default_node_pool["initial_node_count"])
  max_pods_per_node  = lookup(var.node_pool[count.index], "max_pods_per_node", var.default_node_pool["max_pods_per_node"])

  node_config {
    machine_type    = lookup(var.node_pool[count.index], "machine_type", var.default_node_pool["machine_type"])
    local_ssd_count = lookup(var.node_pool[count.index], "local_ssd_count", var.default_node_pool["local_ssd_count"])
    disk_size_gb    = lookup(var.node_pool[count.index], "disk_size_gb", var.default_node_pool["disk_size_gb"])
    disk_type       = lookup(var.node_pool[count.index], "disk_type", var.default_node_pool["disk_type"])
    image_type      = lookup(var.node_pool[count.index], "image_type", var.default_node_pool["image_type"])
    labels          = var.labels

    metadata = var.metadata

    tags         = var.network_tags
    oauth_scopes = var.oauth_scopes


    dynamic "workload_metadata_config" {
      for_each = lookup(var.node_pool[count.index], "workload_identity_enabled", var.default_node_pool["workload_identity_enabled"]) ? ["true"] : []
      content {
        mode = "GKE_METADATA"
      }
    }

    service_account = lookup(var.node_pool[count.index], "service_account", null)

  }
}
