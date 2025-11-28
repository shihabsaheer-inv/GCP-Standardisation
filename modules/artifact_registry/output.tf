# Repository basic outputs
output "repository_id" {
  description = "The ID of the Artifact Registry repository"
  value       = google_artifact_registry_repository.repo[0].repository_id
}

output "repository_name" {
  description = "The name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.repo[0].name
}

output "location" {
  description = "The location of the Artifact Registry repo"
  value       = google_artifact_registry_repository.repo[0].location
}

output "format" {
  description = "Repository format (e.g., DOCKER)"
  value       = google_artifact_registry_repository.repo[0].format
}

# Full Artifact Registry URL
output "repository_url" {
  description = "Full Artifact Registry URL for pushing images"
  value       = google_artifact_registry_repository.repo[0].registry_uri
}

# IAM bindings applied
output "applied_iam_bindings" {
  description = "IAM bindings applied to the Artifact Registry repository"
  value       = var.iam_bindings
}
