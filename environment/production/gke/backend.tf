terraform {
  backend "gcs" {
    bucket = "hhc-global-iac-tfstate"
    prefix = "hhc-global-networking-iac/production/gke"
  }
}
