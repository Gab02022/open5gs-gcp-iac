resource "google_storage_bucket" "terraform_state" {
  name          = "open5gs-tf-state-gabriel-479200" 
  location      = "US"
  force_destroy = false

  # 
  versioning {
    enabled = true
  }

  #
  uniform_bucket_level_access = true
}
