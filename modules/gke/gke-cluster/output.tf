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