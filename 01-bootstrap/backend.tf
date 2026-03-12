terraform {
  backend "gcs" {
    bucket = "open5gs-tf-state-gabriel-479200" 
    prefix = "terraform/bootstrap/state"
  }
}
