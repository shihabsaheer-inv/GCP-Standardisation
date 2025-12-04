terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.10.0"
    }
    # ✅ ADD THIS - Required for google_project_service_identity
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 7.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}