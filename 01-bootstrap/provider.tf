terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "open5gs-479200"
  region  = "us-central1" # Puedes cambiarla si prefieres otra región
}
