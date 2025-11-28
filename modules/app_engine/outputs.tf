# modules/app_engine/outputs.tf

output "environment_url" {
  description = "App Engine service URL (appspot)"
  value       = "https://${var.service_name}-dot-${var.project_id}.appspot.com"
}

output "service_name" {
  value = var.service_name
}

output "version_id" {
  value = (
    var.environment_type == "standard"
    ? (
        length(google_app_engine_standard_app_version.standard) > 0
        ? google_app_engine_standard_app_version.standard[0].version_id
        : null
      )
    : (
        length(google_app_engine_flexible_app_version.flex) > 0
        ? google_app_engine_flexible_app_version.flex[0].version_id
        : null
      )
  )
}
