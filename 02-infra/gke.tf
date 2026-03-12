# 1. Definición del Clúster GKE
resource "google_container_cluster" "primary" {
  name     = "open5gs-cluster" # --cluster-name
  location = "us-central1-a"   # --zone

  deletion_protection = false

  # Lo conectamos a la VPC que creamos en el paso anterior
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  depends_on = [
    google_project_service.container
  ]
}

# 2. Definición de los Nodos
resource "google_container_node_pool" "primary_nodes" {
  name       = "open5gs-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  
  node_count = 1 # --num-nodes 1

  node_config {
    machine_type = "e2-standard-4"     # --machine-type
    image_type   = "UBUNTU_CONTAINERD" # --image-type
    spot         = true                # --spot

    disk_size_gb = 50

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
