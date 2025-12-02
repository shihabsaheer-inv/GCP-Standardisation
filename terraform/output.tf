# ═════════════════════════════════════════════════════════════════════════════
# 🌐 VPC OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "vpc_id" {
  value       = var.enable_vpc ? module.vpc[0].vpc_id : null
  description = "The ID of the created VPC"
}

output "vpc_self_link" {
  value       = var.enable_vpc ? module.vpc[0].network_self_link : null
  description = "Self link of the VPC"
}

output "public_subnet_ids" {
  value       = var.enable_vpc ? module.vpc[0].public_subnet_ids : []
  description = "The IDs of the created public subnets"
}

output "private_subnet_ids" {
  value       = var.enable_vpc ? module.vpc[0].private_subnet_ids : []
  description = "The IDs of the created private subnets"
}

# ═════════════════════════════════════════════════════════════════════════════
# 🔥 FIREWALL OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "firewall_rules" {
  description = "List of created firewall rule IDs"

  value = (var.enable_firewall && var.enable_vpc) ? [
    try(module.firewall[0].ssh_firewall_id, null),
    try(module.firewall[0].internal_firewall_id, null)
  ] : []
}


# ═════════════════════════════════════════════════════════════════════════════
# 🗄️ STORAGE OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "storage_bucket_name" {
  value       = var.enable_storage ? module.storage[0].bucket_name : null
  description = "The name of the storage bucket"
}

output "storage_bucket_url" {
  value       = var.enable_storage ? module.storage[0].bucket_url : null
  description = "The URL of the storage bucket"
}

# ═════════════════════════════════════════════════════════════════════════════
# 🗃️ CLOUD SQL OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "cloudsql_instance_name" {
  value       = var.enable_cloudsql ? module.cloudsql[0].instance_name : null
  description = "Cloud SQL instance name"
}

output "cloudsql_instance_connection_name" {
  value       = var.enable_cloudsql ? module.cloudsql[0].instance_connection_name : null
  description = "Cloud SQL connection name"
}

output "cloudsql_instance_private_ip" {
  value       = var.enable_cloudsql ? module.cloudsql[0].instance_private_ip_address : null
  description = "Private IP of Cloud SQL instance"
}

output "cloudsql_instance_public_ip" {
  value       = var.enable_cloudsql ? module.cloudsql[0].instance_public_ip_address : null
  description = "Public IP of Cloud SQL instance"
}

output "cloudsql_database_names" {
  value       = var.enable_cloudsql ? module.cloudsql[0].database_names : []
  description = "List of created databases"
}

output "cloudsql_user_names" {
  value       = var.enable_cloudsql ? module.cloudsql[0].user_names : []
  description = "List of created db usernames"
  sensitive   = true
}

output "cloudsql_generated_password" {
  value       = var.enable_cloudsql ? module.cloudsql[0].generated_password : null
  description = "Auto-generated DB root/user password"
  sensitive   = true
}

output "cloudsql_service_account_email" {
  value       = var.enable_cloudsql ? module.cloudsql[0].service_account_email : null
  description = "Cloud SQL service account email"
}

# ═════════════════════════════════════════════════════════════════════════════
# ☁️ CLOUD RUN OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "cloud_run_service_name" {
  value       = var.enable_cloudrun ? module.cloud_run[0].service_name : null
  description = "Cloud Run service name"
}

output "cloud_run_url" {
  value       = var.enable_cloudrun ? module.cloud_run[0].service_url : null
  description = "Public HTTPS URL for the Cloud Run service"
}

output "cloud_run_revision" {
  value       = var.enable_cloudrun ? module.cloud_run[0].latest_revision : null
  description = "Latest Cloud Run revision"
}

output "cloud_run_sa" {
  value       = var.enable_cloudrun ? var.cloudrun_service_account_email : null
  description = "Service Account used by Cloud Run"
}

output "cloud_run_cloudsql_connection_enabled" {
  value       = var.enable_cloudrun_cloudsql_connection
  description = "Indicates whether Cloud Run → Cloud SQL connection is enabled"
}

# ═════════════════════════════════════════════════════════════════════════════
# 🔐 IAM OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════
output "iam_cloudrun_sql_binding" {
  value       = (var.enable_cloudrun && var.enable_cloudsql && var.enable_cloudrun_cloudsql_connection) ? google_project_iam_member.cloudrun_sql_client[0].role : null
  description = "IAM binding applied to Cloud Run for Cloud SQL"
}

# ═════════════════════════════════════════════════════════════════════════════
# 🌐 LOAD BALANCER OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

# Correct LB Output Names Based on Module
output "lb_ip_address" {
  value       = var.enable_load_balancer ? module.load_balancer[0].lb_ip : null
  description = "Global IP address of the load balancer"
}

output "lb_http_forwarding_rule" {
  value       = var.enable_load_balancer ? module.load_balancer[0].http_forwarding_rule : null
  description = "HTTP forwarding rule self link"
}

output "lb_https_forwarding_rule" {
  value       = var.enable_load_balancer ? module.load_balancer[0].https_forwarding_rule : null
  description = "HTTPS forwarding rule self link"
}

output "lb_backend_service" {
  value       = var.enable_load_balancer ? module.load_balancer[0].backend_service : null
  description = "Backend service self link"
}

output "lb_cdn_enabled" {
  value       = var.lb_enable_cdn
  description = "Whether CDN is enabled on the backend"
}

output "lb_https_enabled" {
  value       = var.lb_create_https_listener
  description = "Whether HTTPS is enabled for the LB"
}

# ═════════════════════════════════════════════════════════════════════════════
# 📦 ARTIFACT REGISTRY OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

output "artifact_registry_repo_name" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].repository_name : null
  description = "Artifact Registry repository name"
}

output "artifact_registry_repo_id" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].repository_id : null
  description = "Artifact Registry repository ID"
}

output "artifact_registry_repo_location" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].location : null
  description = "Artifact Registry repository location"
}

output "artifact_registry_repo_format" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].format : null
  description = "Artifact Registry repository format"
}

output "artifact_registry_repo_url" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].repository_url : null
  description = "Full Artifact Registry URL"
}

output "artifact_registry_iam_bindings" {
  value       = var.enable_artifact_registry ? module.artifact_registry[0].applied_iam_bindings : null
  description = "IAM bindings applied to Artifact Registry"
}

# ═════════════════════════════════════════════════════════════════════════════
# GENERAL OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

output "project_id" {
  value       = var.project_id
  description = "Project ID used for deployment"
}

output "region" {
  value       = var.region
  description = "Deployment region"
}

output "environment" {
  value       = var.environment
  description = "Environment name (dev/staging/prod)"
}

# ═════════════════════════════════════════════════════════════════════════════
# MEMORY STORE OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

output "memorystore_redis_instance_id" {
  value = module.memorystore.redis_instance_id
}

output "memorystore_redis_cluster_id" {
  value = module.memorystore.redis_cluster_id
}

output "memorystore_memcached_id" {
  value = module.memorystore.memcached_id
}

output "memorystore_endpoint" {
  value = module.memorystore.endpoint
}

# CDN OUTPUTS
output "cdn_url_map" {
  value = module.cloud_cdn.url_map
}


output "cdn_backend_service" {
  value = module.cloud_cdn.backend_service
}

output "cdn_edge_ip" {
  value = module.cloud_cdn.forwarding_rule_ip
}

# Cloud Monitoring
output "monitoring_log_bucket_name" {
  description = "Name of the log bucket created by Cloud Monitoring module"
  value       = try(module.cloud_monitoring[0].log_bucket_name, null)
}

output "monitoring_alert_policy_name" {
  description = "Name of the alert policy created"
  value       = try(module.cloud_monitoring[0].alert_policy_name, null)
}

output "monitoring_notification_channels" {
  description = "List of monitoring notification channel names"
  value       = try(module.cloud_monitoring[0].notification_channels, [])
}
