terraform {
  backend "gcs" {
    bucket = "open5gs-tf-state-gabriel-479200"
    prefix = "terraform/argocd/state" 
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "open5gs-479200"
  region  = "us-central1"
}

# 1. Obtenemos el token de acceso de nuestra Service Account
data "google_client_config" "default" {}

# 2. Obtenemos los datos del clúster que se creó en la capa 02-infra
data "google_container_cluster" "primary" {
  name     = "open5gs-cluster"
  location = "us-central1-a"
}

# 3. Configuramos el provider de Helm para que use esas credenciales
provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}
