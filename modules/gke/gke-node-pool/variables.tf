variable "project" {
  type        = string
  description = "GCP project"
}

variable "region" {
  type        = string
  description = "Default Google Cloud region"
}

variable "cluster_name" {
  type        = list(any)
  description = "Cluster name to which node_pool to be attached"
}

variable "node_pool" {
  type        = list(any)
  description = "GKE Node Pool variable declaration."
  default     = []
}

variable "default_node_pool" {
  type        = map(string)
  description = "Default values of the GKE Node Pool Variable values."
  default = {
    "name"                      = "my-node-pool"
    "auto_repair"               = "true"
    "auto_upgrade"              = "true"
    "disk_type"                 = "pd-balanced"
    "image_type"                = "COS_CONTAINERD"
    "local_ssd_count"           = "0"
    "disk_size_gb"              = "100"
    "machine_type"              = "e2-standard-2"
    "max_pods_per_node"         = "16"
    "min_node_count"            = "1"
    "max_node_count"            = "5"
    "initial_node_count"        = "1"
    "workload_identity_enabled" = "true"
    "version"                   = ""
  }
}

variable "network_tags" {
  type        = list(any)
  description = "The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls."
  default     = ["gke-node-pool-network-tag"]
}

variable "oauth_scopes" {
  type        = list(any)
  description = "The set of Google API scopes to be made available on all of the node VMs under the default service account."
  #default     = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring"]
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "labels" {
  type        = map(any)
  description = ""
  default = {
    "deployed" = "terraform"
  }
}

variable "metadata" {
  type        = map(any)
  description = "Map variable to pass metadata for the compute nodes."
  default = {
    disable-legacy-endpoints = "true"
  }
}

variable "suffix" {
  type        = string
  description = "variable to append a string for each resoure to have unique name based on the jenkins branch name."
  default     = ""
}
