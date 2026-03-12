terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "gcs" {
    bucket = "open5gs-tf-state-gabriel-479200" 
    prefix = "terraform/infra/state"          
  }
}

provider "google" {
  project = "open5gs-479200"
  region  = "us-central1"
  zone    = "us-central1-a"
}
