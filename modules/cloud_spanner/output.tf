output "instance_name" {
  description = "Cloud Spanner instance name"
  value       = google_spanner_instance.this.name
}

output "instance_config" {
  description = "Cloud Spanner instance config"
  value       = google_spanner_instance.this.config
}

output "database_name" {
  description = "Cloud Spanner database name"
  value       = google_spanner_database.this.name
}

output "instance_state" {
  description = "Cloud Spanner instance state (e.g. 'READY')"
  value       = google_spanner_instance.this.state
}

output "instance_id" {
  value = google_spanner_instance.this.id
}

output "database_id" {
  value = google_spanner_database.this.id
}