# ═════════════════════════════════════════════════════════════════════════════
# GKE MODULE OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────
# 🌐 CLUSTER OUTPUTS
# ─────────────────────────────
output "cluster_id" {
  description = "The ID of the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].id : null
}

output "cluster_name" {
  description = "The name of the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].name : null
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = var.create_cluster ? google_container_cluster.primary[0].endpoint : null
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate (base64 encoded)"
  value       = var.create_cluster ? google_container_cluster.primary[0].master_auth[0].cluster_ca_certificate : null
  sensitive   = true
}

output "cluster_master_version" {
  description = "The current version of the master in the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].master_version : null
}

output "cluster_location" {
  description = "The location of the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].location : null
}

output "cluster_region" {
  description = "The region of the cluster (if regional)"
  value       = var.create_cluster ? google_container_cluster.primary[0].location : null
}

output "cluster_zones" {
  description = "The zones in which the cluster resides"
  value       = var.create_cluster ? google_container_cluster.primary[0].node_locations : null
}

output "cluster_self_link" {
  description = "The server-defined URL for the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].self_link : null
}

# ─────────────────────────────
# 🔐 AUTHENTICATION OUTPUTS
# ─────────────────────────────
output "cluster_master_auth" {
  description = "The authentication information for accessing the Kubernetes master"
  value       = var.create_cluster ? google_container_cluster.primary[0].master_auth : null
  sensitive   = true
}

output "workload_identity_config" {
  description = "Workload Identity configuration"
  value       = var.create_cluster && var.enable_workload_identity ? google_container_cluster.primary[0].workload_identity_config : null
}

# ─────────────────────────────
# 🔗 NETWORKING OUTPUTS
# ─────────────────────────────
output "network" {
  description = "The VPC network in which the cluster resides"
  value       = var.create_cluster ? google_container_cluster.primary[0].network : null
}

output "subnetwork" {
  description = "The subnetwork in which the cluster resides"
  value       = var.create_cluster ? google_container_cluster.primary[0].subnetwork : null
}

output "cluster_ipv4_cidr" {
  description = "The IP address range of the Kubernetes pods"
  value       = var.create_cluster ? google_container_cluster.primary[0].cluster_ipv4_cidr : null
}

output "services_ipv4_cidr" {
  description = "The IP address range of the Kubernetes services"
  value       = var.create_cluster ? google_container_cluster.primary[0].services_ipv4_cidr : null
}

output "private_cluster_config" {
  description = "Private cluster configuration"
  value       = var.create_cluster && var.enable_private_cluster ? google_container_cluster.primary[0].private_cluster_config : null
}

# ─────────────────────────────
# 🖥️ NODE POOL OUTPUTS
# ─────────────────────────────
output "node_pools" {
  description = "Map of node pools and their attributes"
  value = var.create_cluster && var.create_node_pool ? {
    for k, v in google_container_node_pool.primary : k => {
      name               = v.name
      location           = v.location
      node_count         = v.node_count
      initial_node_count = v.initial_node_count
      version            = v.version
      instance_group_urls = v.instance_group_urls
      managed_instance_group_urls = v.managed_instance_group_urls
    }
  } : null
}

output "node_pool_names" {
  description = "List of node pool names"
  value       = var.create_cluster && var.create_node_pool ? [for k, v in google_container_node_pool.primary : v.name] : null
}

output "node_pool_instance_group_urls" {
  description = "Map of node pool instance group URLs"
  value = var.create_cluster && var.create_node_pool ? {
    for k, v in google_container_node_pool.primary : k => v.instance_group_urls
  } : null
}

# ─────────────────────────────
# 📊 MONITORING & LOGGING OUTPUTS
# ─────────────────────────────
output "monitoring_service" {
  description = "The monitoring service used by the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].monitoring_service : null
}

output "logging_service" {
  description = "The logging service used by the cluster"
  value       = var.create_cluster ? google_container_cluster.primary[0].logging_service : null
}

# ─────────────────────────────
# 🔌 ADDON OUTPUTS
# ─────────────────────────────
output "addons_config" {
  description = "The configuration for addons supported by GKE"
  value       = var.create_cluster ? google_container_cluster.primary[0].addons_config : null
}

# ─────────────────────────────
# 🔄 RELEASE CHANNEL OUTPUT
# ─────────────────────────────
output "release_channel" {
  description = "The release channel of the cluster"
  value       = var.create_cluster && var.release_channel != null ? google_container_cluster.primary[0].release_channel : null
}

# ─────────────────────────────
# 🛠️ USEFUL COMMANDS OUTPUT
# ─────────────────────────────
output "kubectl_command" {
  description = "Command to configure kubectl"
  value       = var.create_cluster ? "gcloud container clusters get-credentials ${google_container_cluster.primary[0].name} --region=${google_container_cluster.primary[0].location} --project=${var.project_id}" : null
}

output "cluster_connection_config" {
  description = "Configuration for connecting to the cluster"
  value = var.create_cluster ? {
    cluster_name = google_container_cluster.primary[0].name
    location     = google_container_cluster.primary[0].location
    project_id   = var.project_id
  } : null
}