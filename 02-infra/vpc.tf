# 1. Habilitar las APIs necesarias para GKE
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# 2. Crear la red principal (VPC)
resource "google_compute_network" "vpc" {
  name                    = "open5gs-vpc"
  auto_create_subnetworks = false # Falso para tener control
  depends_on              = [google_project_service.compute]
}

# 3. Crear la subred para el clúster
resource "google_compute_subnetwork" "subnet" {
  name          = "open5gs-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/16" 
}
