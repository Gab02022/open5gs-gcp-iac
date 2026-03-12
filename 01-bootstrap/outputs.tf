output "workload_identity_provider" {
  description = "El ID exacto que GitHub Actions necesita para conectarse a GCP"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

output "service_account_email" {
  description = "El correo de la Service Account que asumirá GitHub Actions"
  value       = google_service_account.github_actions_sa.email
}
