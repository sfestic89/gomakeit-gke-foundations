output "gke_name" {
  description = "GKE Name"
  value       = google_container_cluster.primary.name

}

output "service_account" {
  description = "GKE SA Name"
  value       = google_service_account.default.email

}
