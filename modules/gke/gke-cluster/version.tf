terraform {
  required_version = ">= 0.12.20"
  required_providers {
    google      = ">= 4.0.0"
    google-beta = ">= 4.0.0"
    null        = ">= 2.1"
    random      = ">= 2.2"
  }
}

-------------
data.tf

terraform {
  required_version = ">= 0.12.20"
  required_providers {
    google      = ">= 4.0.0"
    google-beta = ">= 4.0.0"
    null        = ">= 2.1"
    random      = ">= 2.2"
  }
}


-----------

outputs.tf

output "gke-name" {
  description = "gke cluster name"
  value       = google_container_cluster.cluster.*.name
}

output "location" {
  description = "region of gke cluster"
  value       = google_container_cluster.cluster.*.location
}

output "master_version" {
  description = "master version of gke cluster"
  value       = google_container_cluster.cluster.*.master_version
}
