# Habilitar la API necesaria para Workload Identity
resource "google_project_service" "iamcredentials" {
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

# 1. Crear la Service Account que GitHub usará de forma temporal
resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-sa"
  display_name = "Service Account para GitHub Actions IaC"
}

# 2. Darle permisos a esta Service Account 
# Definimos los roles estrictamente necesarios
locals {
  github_sa_roles = [
    "roles/compute.networkAdmin",
    "roles/container.admin",
    "roles/iam.serviceAccountUser"
  ]
}

# Asignamos roles en bucle
resource "google_project_iam_member" "sa_roles" {
  for_each = toset(local.github_sa_roles)
  
  project = "open5gs-479200"
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

# 3. Crear el Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
}

# 4. Crear el Identity Provider (Conectando el Pool con GitHub OIDC)
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"
  
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  
  # 
  attribute_condition = "assertion.repository == 'Gab02022/open5gs-gcp-iac'"
  
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# 5. Permitir que SOLO repositorio asuma esta identidad
resource "google_service_account_iam_member" "github_actions_iam" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/Gab02022/open5gs-gcp-iac"
}
