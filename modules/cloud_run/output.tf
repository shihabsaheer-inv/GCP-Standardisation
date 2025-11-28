##############################################################
# Outputs
##############################################################

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = try(google_cloud_run_service.this[0].name, null)
}

output "service_url" {
  description = "Public URL of the Cloud Run service"
  value       = try(google_cloud_run_service.this[0].status[0].url, null)
}

output "latest_revision" {
  description = "Latest ready revision name"
  value       = try(google_cloud_run_service.this[0].status[0].latest_ready_revision_name, null)
}

output "service_id" {
  description = "Cloud Run service ID"
  value       = try(google_cloud_run_service.this[0].id, null)
}
