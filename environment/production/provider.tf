terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      project = var.project_id
      version = ">= 5.0"
    }
  }
}
