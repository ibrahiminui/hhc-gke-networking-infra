terraform {
  backend "gcs" {
  }
}

resource "google_container_cluster" "cluster" {
  count                       = length(var.gke_cluster)
  project                     = var.project_id
  provider                    = google-beta
  name                        = format("%s%s", lookup(var.gke_cluster[count.index], "name"), var.suffix)
  description                 = lookup(var.gke_cluster[count.index], "description", var.default_gke_cluster["description"])
  default_max_pods_per_node   = lookup(var.gke_cluster[count.index], "default_max_pods_per_node", var.default_gke_cluster["default_max_pods_per_node"])
  location                    = var.region
  network                     = data.google_compute_network.gke_network.self_link
  subnetwork                  = data.google_compute_subnetwork.gke_subnetwork.self_link
  logging_service             = lookup(var.gke_cluster[count.index], "logging_service", var.default_gke_cluster["logging_service"])
  monitoring_service          = lookup(var.gke_cluster[count.index], "monitoring_service", var.default_gke_cluster["monitoring_service"])
  networking_mode             = "VPC_NATIVE"
  remove_default_node_pool    = true
  deletion_protection         = false
  initial_node_count          = 1
  min_master_version          = lookup(var.gke_cluster[count.index], "min_master_version", var.default_gke_cluster["min_master_version"])
  enable_shielded_nodes       = lookup(var.gke_cluster[count.index], "enable_shielded_nodes", var.default_gke_cluster["enable_shielded_nodes"])
  enable_intranode_visibility = lookup(var.gke_cluster[count.index], "enable_intranode_visibility", var.default_gke_cluster["enable_intranode_visibility"])
  release_channel {
    channel = lookup(var.gke_cluster[count.index], "release_channel", var.default_gke_cluster["release_channel"])
  }

  cluster_autoscaling {
    enabled = lookup(var.gke_cluster[count.index], "cluster_autoscaling_enabled", var.default_gke_cluster["cluster_autoscaling_enabled"])
    dynamic "resource_limits" {
      for_each = lookup(var.gke_cluster[count.index], "cluster_autoscaling_enabled", var.default_gke_cluster["cluster_autoscaling_enabled"]) ? var.resource_type : []
      content {
        resource_type = resource_limits.value["resource_type"]
        maximum       = resource_limits.value["cluster_autoscaling_max"]
        minimum       = resource_limits.value["cluster_autoscaling_min"]
      }
    }
    autoscaling_profile = lookup(var.gke_cluster[count.index], "autoscaling_profile", var.default_gke_cluster["autoscaling_profile"])
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # enables RBAC with Google Groups
  dynamic "authenticator_groups_config" {
    for_each = lookup(var.gke_cluster[count.index], "authenticator_groups_config_enabled", var.default_gke_cluster["authenticator_groups_config_enabled"]) ? ["true"] : []
    content {
      # this must be hard coded for RBAC to work with Google Groups
      security_group = "gke-security-groups@ncr.com"
    }
  }

  dynamic "workload_identity_config" {
    for_each = lookup(var.gke_cluster[count.index], "workload_identity_enabled", var.default_gke_cluster["workload_identity_enabled"]) ? ["true"] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = lookup(var.gke_cluster[count.index], "cluster_secondary_range_name")
    services_secondary_range_name = lookup(var.gke_cluster[count.index], "services_secondary_range_name")
  }

  private_cluster_config {
    enable_private_endpoint = lookup(var.gke_cluster[count.index], "enable_private_endpoint", var.default_gke_cluster["enable_private_endpoint"])
    enable_private_nodes    = lookup(var.gke_cluster[count.index], "enable_private_nodes", var.default_gke_cluster["enable_private_nodes"])
    master_ipv4_cidr_block  = lookup(var.gke_cluster[count.index], "master_ipv4_cidr_block", var.default_gke_cluster["master_ipv4_cidr_block"])
  }

  dynamic "database_encryption" {
    for_each = lookup(var.gke_cluster[count.index], "enable_database_encryption", var.default_gke_cluster["enable_database_encryption"]) ? var.database_encryption : []
    content {
      key_name = element(data.google_kms_crypto_key.crypto_key.*.id, count.index)
      state    = lookup(var.gke_cluster[count.index], "state", database_encryption.value.state)
    }
  }

  vertical_pod_autoscaling {
    enabled = lookup(var.gke_cluster[count.index], "vertical_pod_autoscaling", var.default_gke_cluster["vertical_pod_autoscaling"])
  }

  addons_config {
    #using enable_network_policy varible twice to enable network policies
    network_policy_config {
      disabled = !lookup(var.gke_cluster[count.index], "disable_network_policy", var.default_gke_cluster["enable_network_policy"])
    }

    horizontal_pod_autoscaling {
      disabled = lookup(var.gke_cluster[count.index], "disable_horizontal_pod_autoscaling", var.default_gke_cluster["horizontal_pod_autoscaling"])
    }

    http_load_balancing {
      disabled = lookup(var.gke_cluster[count.index], "disable_http_load_balancing", var.default_gke_cluster["http_load_balancing"])
    }

    istio_config {
      disabled = lookup(var.gke_cluster[count.index], "disable_istio_config", var.default_gke_cluster["istio_config"])
    }

    config_connector_config {
      enabled = lookup(var.gke_cluster[count.index], "config_connector_config", var.default_gke_cluster["config_connector_config"])
    }

    gke_backup_agent_config {
      enabled = lookup(var.gke_cluster[count.index], "gke_backup_agent_config", var.default_gke_cluster["gke_backup_agent_config"])
    }
  }

  network_policy {
    enabled  = lookup(var.gke_cluster[count.index], "enable_network_policy", var.default_gke_cluster["enable_network_policy"])
    provider = lookup(var.gke_cluster[count.index], "network_policy_provider", var.default_gke_cluster["network_policy_provider"])
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  maintenance_policy {
    dynamic "daily_maintenance_window" {
      for_each = (lookup(var.gke_cluster[count.index], "daily_maintenance_enabled", var.default_gke_cluster["daily_maintenance_enabled"]) ? ["1"] : [])
      content {
        start_time = lookup(var.gke_cluster[count.index], "maintenance_start_time", var.default_gke_cluster["maintenance_start_time"])
      }
    }
    dynamic "recurring_window" {
      for_each = (lookup(var.gke_cluster[count.index], "daily_maintenance_enabled", var.default_gke_cluster["daily_maintenance_enabled"]) ? [] : ["1"])
      content {
        start_time = lookup(var.gke_cluster[count.index], "maintenance_start_time", var.default_gke_cluster["maintenance_start_time"])
        end_time   = lookup(var.gke_cluster[count.index], "maintenance_end_time", var.default_gke_cluster["maintenance_end_time"])
        recurrence = lookup(var.gke_cluster[count.index], "maintenance_recurrence", var.default_gke_cluster["maintenance_recurrence"])
      }
    }
  }

  resource_labels = var.labels

  lifecycle {
    ignore_changes = [node_pool, initial_node_count, maintenance_policy[0].maintenance_exclusion]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  default_snat_status {
    disabled = lookup(var.gke_cluster[count.index], "disable_default_snat", var.default_gke_cluster["disable_default_snat"])
  }

  depends_on = [null_resource.dependency_resource]
}

resource "null_resource" "dependency_resource" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

