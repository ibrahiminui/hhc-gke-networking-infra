
module "hhc-shared-prd-wug02-gke-1" {
  source = "../../../modules/gke-cluster"

  project = var.project_id
  region  = "us-west2"

  network    = "hhc-shared-prd-vpc"
  subnetwork = "hhc-shared-prd-wug02"

  gke_cluster = [{
    name                          = "hhc-shared-prd-wug02-gke-1"
    enable_shielded_nodes         = "false"
    cluster_secondary_range_name  = "hhc-shared-prd-wug02-pod-1"
    services_secondary_range_name = "hhc-shared-prd-wug02-service-1"
    master_ipv4_cidr_block        = "172.16.4.128/28"
    autoscaling_profile           = "BALANCED"
    maintenance_start_time        = "2023-05-01T06:00:00Z"
    maintenance_end_time          = "2023-05-01T10:00:00Z"
    maintenance_recurrence        = "FREQ=WEEKLY;BYDAY=TU,WE,TH"
  }]
}

module "hhc-shared-prd-wug02-gke-1-np1" {
  source       = "../../../modules/gke-node-pool"
  project      = var.project_id
  region       = "us-west2"
  cluster_name = module.hhc-shared-prd-wug02-gke-1.gke-name
  oauth_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
  node_pool = [
    {
      "name"              = "default-pool-wug02-1",
      "machine_type"      = "e2-standard-2",
      "max_node_count"    = "3",
      "max_pods_per_node" = "48",
      "service_account"   = module.default_nodepool_service_account.email,
      "disk_size_gb"      = "20",
    },
  ]
  network_tags = ["gke", "prd", "prod", "gke-prd", "wug02"]
}
