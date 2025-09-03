terraform {
  required_version = "1.12.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.42"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.42"
    }
  }
}
------------------------
provider.tf

terraform {
  required_version = "1.12.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.42"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.42"
    }
  }
}
