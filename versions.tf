terraform {
  required_version = ">= 1.5.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50, < 5.11.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.26, < 5.15.0"
    }
  }
}
