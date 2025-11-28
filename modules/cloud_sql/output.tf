# Cloud SQL Module Outputs - Comprehensive Information for Integration

# Instance Outputs
output "instance_id" {
  description = "The ID of the Cloud SQL instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].id : null
}

output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].name : null
}

output "instance_self_link" {
  description = "The URI of the Cloud SQL instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].self_link : null
}

output "instance_connection_name" {
  description = "The connection name of the instance to be used in connection strings"
  value       = var.create_instance ? google_sql_database_instance.this[0].connection_name : null
}

output "instance_service_account_email" {
  description = "The service account email address assigned to the instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].service_account_email_address : null
}

# Network Information
output "instance_ip_address" {
  description = "The IPv4 address assigned for the instance"
  value       = var.create_instance && var.ipv4_enabled ? google_sql_database_instance.this[0].ip_address : null
}

output "instance_public_ip_address" {
  description = "The first public IPv4 address assigned"
  value       = var.create_instance && var.ipv4_enabled ? google_sql_database_instance.this[0].public_ip_address : null
}

output "instance_private_ip_address" {
  description = "The first private IPv4 address assigned"
  value       = var.create_instance ? google_sql_database_instance.this[0].private_ip_address : null
}

output "instance_first_ip_address" {
  description = "The first IPv4 address assigned"
  value       = var.create_instance ? google_sql_database_instance.this[0].first_ip_address : null
}

output "instance_ip_addresses" {
  description = "All IP addresses assigned to the instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].ip_address : null
}

# Database Information
output "instance_server_ca_cert" {
  description = "The CA certificate information for SSL"
  value       = var.create_instance ? google_sql_database_instance.this[0].server_ca_cert : null
  sensitive   = true
}

output "database_version" {
  description = "The database version running on the instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].database_version : null
}

output "instance_settings_version" {
  description = "The version of instance settings"
  value       = var.create_instance ? google_sql_database_instance.this[0].settings[0].version : null
}

# Database Names
output "database_names" {
  description = "List of database names created"
  value       = [for db in google_sql_database.databases : db.name]
}

output "database_ids" {
  description = "Map of database names to their IDs"
  value       = { for k, db in google_sql_database.databases : k => db.id }
}

# User Information
output "user_names" {
  description = "List of database user names created"
  value       = [for user in google_sql_user.users : user.name]
  sensitive   = true
}

output "generated_password" {
  description = "The generated random password (if enabled)"
  value       = var.generate_random_password ? random_password.db_password[0].result : null
  sensitive   = true
}

# Read Replica Information
output "replica_instance_names" {
  description = "List of read replica instance names"
  value       = var.create_read_replica ? google_sql_database_instance.replicas[*].name : []
}

output "replica_connection_names" {
  description = "List of read replica connection names"
  value       = var.create_read_replica ? google_sql_database_instance.replicas[*].connection_name : []
}

output "replica_ip_addresses" {
  description = "List of read replica IP addresses"
  value       = var.create_read_replica ? google_sql_database_instance.replicas[*].first_ip_address : []
}

output "replica_self_links" {
  description = "List of read replica self links"
  value       = var.create_read_replica ? google_sql_database_instance.replicas[*].self_link : []
}

# KMS Information
output "kms_key_ring_id" {
  description = "The ID of the KMS key ring"
  value       = var.create_kms_key ? google_kms_key_ring.cloudsql[0].id : null
}

output "kms_crypto_key_id" {
  description = "The ID of the KMS crypto key"
  value       = var.create_kms_key ? google_kms_crypto_key.cloudsql[0].id : null
}

output "kms_crypto_key_name" {
  description = "The resource name of the KMS crypto key"
  value       = var.create_kms_key ? google_kms_crypto_key.cloudsql[0].name : null
}

# Service Account Information
output "service_account_email" {
  description = "Email address of the created service account"
  value       = var.create_service_account ? google_service_account.cloudsql[0].email : null
}

output "service_account_id" {
  description = "ID of the created service account"
  value       = var.create_service_account ? google_service_account.cloudsql[0].id : null
}

# Monitoring Information
output "monitoring_alert_ids" {
  description = "Map of monitoring alert policy IDs"
  value = var.create_monitoring_alerts ? {
    cpu_utilization    = google_monitoring_alert_policy.cpu_utilization[0].id
    memory_utilization = google_monitoring_alert_policy.memory_utilization[0].id
    disk_utilization   = google_monitoring_alert_policy.disk_utilization[0].id
    connections        = google_monitoring_alert_policy.connections[0].id
  } : {}
}

# Connection Information (for applications)
output "connection_info" {
  description = "Database connection information"
  value = var.create_instance ? {
    connection_name = google_sql_database_instance.this[0].connection_name
    ip_address      = google_sql_database_instance.this[0].first_ip_address
    database_names  = [for db in google_sql_database.databases : db.name]
  } : null
}

# Cloud SQL Proxy Connection String
output "cloud_sql_proxy_connection" {
  description = "Connection string for Cloud SQL Proxy"
  value       = var.create_instance ? "gcloud sql connect ${google_sql_database_instance.this[0].name} --user=root" : null
}

# Configuration Summary
output "instance_configuration" {
  description = "Summary of instance configuration"
  value = var.create_instance ? {
    name              = google_sql_database_instance.this[0].name
    database_version  = google_sql_database_instance.this[0].database_version
    tier              = google_sql_database_instance.this[0].settings[0].tier
    availability_type = google_sql_database_instance.this[0].settings[0].availability_type
    disk_size         = google_sql_database_instance.this[0].settings[0].disk_size
    disk_type         = google_sql_database_instance.this[0].settings[0].disk_type
    region            = google_sql_database_instance.this[0].region
    backup_enabled    = google_sql_database_instance.this[0].settings[0].backup_configuration[0].enabled
  } : null
}

# High Availability Status
output "high_availability_enabled" {
  description = "Whether high availability is enabled"
  value       = var.create_instance ? (google_sql_database_instance.this[0].settings[0].availability_type == "REGIONAL") : null
}

# Backup Configuration
output "backup_configuration" {
  description = "Backup configuration details"
  value = var.create_instance ? {
    enabled                        = google_sql_database_instance.this[0].settings[0].backup_configuration[0].enabled
    start_time                     = google_sql_database_instance.this[0].settings[0].backup_configuration[0].start_time
    point_in_time_recovery_enabled = google_sql_database_instance.this[0].settings[0].backup_configuration[0].point_in_time_recovery_enabled
  } : null
}

# Encryption Status
output "encryption_key_name" {
  description = "The encryption key used for the instance"
  value       = var.create_instance ? google_sql_database_instance.this[0].encryption_key_name : null
}

# Project Number
output "project_number" {
  description = "The GCP project number"
  value       = data.google_project.project.number
}