resource "google_compute_router" "dbk-global-shared-router-prod-us-west2" {
  name    = "dbk-global-shared-router-prod-us-west2"
  project = "dbk-global-networking"
  region  = "us-west2"
  network = "dbk-global-shared-network-prod-vpc"

  bgp {
    advertise_mode = "DEFAULT"
    asn            = 65001
  }
}

resource "google_compute_address" "wug02-prod" {
  count   = 8
  name    = "nat-manual-wug02-prod-${count.index}"
  project = "dbk-global-networking"
  region  = "us-west2"
}

resource "google_compute_router_nat" "dbk-global-shared-prod-nat-gateway-us-west2" {
  name    = "dbk-global-shared-prod-nat-gateway-us-west2"
  project = "dbk-global-networking"
  router  = google_compute_router.dbk-global-shared-router-prod-us-west2.name
  region  = "us-west2"

  nat_ip_allocate_option              = "MANUAL_ONLY"
  nat_ips                             = google_compute_address.wug02-prod[*].self_link
  enable_endpoint_independent_mapping = false
  min_ports_per_vm                    = 32
  max_ports_per_vm                    = 65536

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
