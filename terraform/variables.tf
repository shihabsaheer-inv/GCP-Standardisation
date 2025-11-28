# ═════════════════════════════════════════════════════════════════════════════
# VPC VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
variable "enable_vpc" {
  description = "Set to true to create the VPC, false to skip."
  type        = bool
  default     = true
}

variable "region" {
  description = "Region to create resources in."
  type        = string
}

variable "vpc_name" {
  description = "VPC name."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets."
  type        = list(string)
}

variable "project_id" {
  description = "The project in which the subnet is created"
  type        = string
}

# ═════════════════════════════════════════════════════════════════════════════
# COMPUTE ENGINE VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
variable "enable_compute_engine" {
  description = "Toggle to enable or disable the creation of Compute Engine instances"
  type        = bool
  default     = true
}

variable "zone" {
  description = "Zone to create the resources in"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_name_prefix" {
  description = "Prefix for the instance names"
  type        = string
  default     = "gcp-instance"
}

variable "instance_type" {
  description = "Machine type for the instances"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of the boot disk (e.g., pd-standard, pd-ssd)"
  type        = string
  default     = "pd-ssd"
}

variable "image" {
  description = "Image to use for the instances"
  type        = string
  default     = "projects/debian-cloud/global/images/debian-10-buster-v20201014"
}

variable "service_account_email" {
  description = "Service account email for the instances"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the instances"
  type        = bool
  default     = false
}

variable "network_name" {
  description = "The name of the network to attach the instance to"
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "The name of the subnetwork to attach the instance to"
  type        = string
  default     = "default"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address to the instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to the instances"
  type        = map(string)
  default     = {}
}

variable "use_sequential_naming" {
  description = "Use sequential naming for instances"
  type        = bool
  default     = true
}

variable "name_padding" {
  description = "Number of digits to pad the instance name (e.g., 01, 02, 03)"
  type        = number
  default     = 2
}

variable "instance_tags" {
  description = "List of tags to be assigned to the instance"
  type        = list(string)
  default     = []
}

variable "startup_scripts" {
  description = "Map of startup scripts per instance"
  type        = map(string)
  default     = {}
}

variable "instance_roles" {
  type    = map(string)
  default = {}
}

# ═════════════════════════════════════════════════════════════════════════════
# FIREWALL VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
variable "enable_firewall" {
  description = "Toggle to enable or disable the creation of Firewall"
  type        = bool
  default     = false
}

variable "custom_rules" {
  description = "Custom firewall rules list"
  type = list(object({
    name          = string
    protocol      = string
    ports         = optional(list(string))
    source_ranges = list(string)
    target_tags   = optional(list(string))
  }))
  default = []
}

variable "ssh_source_ranges" {
  type = list(string)
}

variable "enable_custom_firewall" {
  description = "Whether to create custom firewall rules"
  type        = bool
  default     = false
}

# ═════════════════════════════════════════════════════════════════════════════
# STORAGE VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
variable "storage_bucket_name" {
  description = "GCS bucket name"
  type        = string
  default     = "my-bucket"
}

variable "storage_force_destroy" {
  description = "Delete all objects in the bucket when destroying"
  type        = bool
  default     = false
}

variable "storage_enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "storage_enable_static_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

variable "storage_index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "storage_error_document" {
  description = "Error document for static website"
  type        = string
  default     = "404.html"
}

variable "storage_enable_public_access" {
  description = "Enable public access for the bucket"
  type        = bool
  default     = false
}

variable "storage_public_access_members" {
  description = "IAM members with public access"
  type        = list(string)
  default     = ["allUsers"]
}

variable "storage_labels" {
  description = "Labels for the bucket"
  type        = map(string)
  default     = {}
}

variable "enable_storage" {
  description = "Enable or disable the storage module"
  type        = bool
  default     = true
}

# ═════════════════════════════════════════════════════════════════════════════
# CLOUD SQL VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
variable "enable_cloudsql" {
  description = "Toggle to enable or disable Cloud SQL instance creation"
  type        = bool
  default     = false
}

# General Configuration
variable "cloudsql_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
  default     = "cloudsql-instance"
}

variable "cloudsql_database_version" {
  description = "Database version (e.g., MYSQL_8_0, POSTGRES_15)"
  type        = string
  default     = "MYSQL_8_0"
}

variable "cloudsql_tier" {
  description = "Machine type for Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "cloudsql_availability_type" {
  description = "Availability type (ZONAL or REGIONAL)"
  type        = string
  default     = "ZONAL"
}

# Storage Configuration
variable "cloudsql_disk_type" {
  description = "Disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "cloudsql_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "cloudsql_disk_autoresize" {
  description = "Enable automatic storage increase"
  type        = bool
  default     = true
}

variable "cloudsql_disk_autoresize_limit" {
  description = "Maximum size for automatic storage increase in GB"
  type        = number
  default     = 100
}

# Backup Configuration
variable "cloudsql_backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "cloudsql_backup_start_time" {
  description = "Backup start time (HH:MM format)"
  type        = string
  default     = "03:00"
}

variable "cloudsql_point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "cloudsql_transaction_log_retention_days" {
  description = "Number of days to retain transaction logs"
  type        = number
  default     = 7
}

variable "cloudsql_retained_backups" {
  description = "Number of backups to retain"
  type        = number
  default     = 7
}

# Network Configuration
variable "cloudsql_ipv4_enabled" {
  description = "Enable public IP address"
  type        = bool
  default     = false
}

variable "cloudsql_require_ssl" {
  description = "Require SSL for connections"
  type        = bool
  default     = true
}

variable "cloudsql_authorized_networks" {
  description = "List of authorized networks"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Maintenance Configuration
variable "cloudsql_maintenance_window_day" {
  description = "Day of week for maintenance (1-7)"
  type        = number
  default     = 7
}

variable "cloudsql_maintenance_window_hour" {
  description = "Hour of day for maintenance (0-23)"
  type        = number
  default     = 5
}

variable "cloudsql_maintenance_window_update_track" {
  description = "Update track (canary or stable)"
  type        = string
  default     = "stable"
}

# Database Flags
variable "cloudsql_database_flags" {
  description = "Database flags to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Query Insights
variable "cloudsql_query_insights_enabled" {
  description = "Enable Query Insights"
  type        = bool
  default     = true
}

variable "cloudsql_query_string_length" {
  description = "Maximum query string length"
  type        = number
  default     = 1024
}

variable "cloudsql_record_application_tags" {
  description = "Record application tags"
  type        = bool
  default     = false
}

variable "cloudsql_record_client_address" {
  description = "Record client address"
  type        = bool
  default     = false
}

# Password Policy
variable "cloudsql_enable_password_policy" {
  description = "Enable password validation policy"
  type        = bool
  default     = true
}

variable "cloudsql_password_policy_min_length" {
  description = "Minimum password length"
  type        = number
  default     = 12
}

variable "cloudsql_password_policy_complexity" {
  description = "Password complexity requirement"
  type        = string
  default     = "COMPLEXITY_DEFAULT"
}

variable "cloudsql_password_policy_reuse_interval" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 5
}

variable "cloudsql_password_policy_disallow_username" {
  description = "Disallow username in password"
  type        = bool
  default     = true
}

# Security
variable "cloudsql_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "cloudsql_create_kms_key" {
  description = "Create KMS key for encryption"
  type        = bool
  default     = true
}

variable "cloudsql_kms_key_rotation_period" {
  description = "KMS key rotation period"
  type        = string
  default     = "7776000s"
}

variable "cloudsql_create_service_account" {
  description = "Create service account for Cloud SQL"
  type        = bool
  default     = false
}

# Databases and Users
variable "cloudsql_databases" {
  description = "Map of databases to create"
  type = map(object({
    name      = string
    charset   = optional(string)
    collation = optional(string)
  }))
  default = {}
}

variable "cloudsql_users" {
  description = "Map of users to create"
  type = map(object({
    name                         = string
    password                     = optional(string)
    host                         = optional(string)
    enable_password_policy       = optional(bool, false)
    allowed_failed_attempts      = optional(number, 5)
    password_expiration_duration = optional(string)
    enable_failed_attempts_check = optional(bool, true)
    enable_password_verification = optional(bool, true)
  }))
  default = {}
}

variable "cloudsql_generate_random_password" {
  description = "Generate random password for users"
  type        = bool
  default     = true
}

# Read Replicas
variable "cloudsql_create_read_replica" {
  description = "Create read replicas"
  type        = bool
  default     = false
}

variable "cloudsql_replica_count" {
  description = "Number of read replicas"
  type        = number
  default     = 1
}

variable "cloudsql_replica_tier" {
  description = "Machine type for replicas"
  type        = string
  default     = null
}

variable "cloudsql_replica_region" {
  description = "Region for replicas"
  type        = string
  default     = null
}

variable "cloudsql_replica_availability_type" {
  description = "Availability type for replicas"
  type        = string
  default     = "ZONAL"
}

variable "cloudsql_replica_ipv4_enabled" {
  description = "Enable public IP for replicas"
  type        = bool
  default     = false
}

variable "cloudsql_replica_failover_target" {
  description = "Set replica as failover target"
  type        = bool
  default     = false
}

variable "cloudsql_replica_deletion_protection" {
  description = "Enable deletion protection for replicas"
  type        = bool
  default     = false
}

# Monitoring
variable "cloudsql_create_monitoring_alerts" {
  description = "Create monitoring alerts"
  type        = bool
  default     = true
}

variable "cloudsql_cpu_utilization_threshold" {
  description = "CPU utilization threshold percentage"
  type        = number
  default     = 80
}

variable "cloudsql_memory_utilization_threshold" {
  description = "Memory utilization threshold percentage"
  type        = number
  default     = 80
}

variable "cloudsql_disk_utilization_threshold" {
  description = "Disk utilization threshold percentage"
  type        = number
  default     = 80
}

variable "cloudsql_connections_threshold" {
  description = "Database connections threshold"
  type        = number
  default     = 80
}

variable "cloudsql_alert_evaluation_period" {
  description = "Alert evaluation period in seconds"
  type        = number
  default     = 300
}

variable "cloudsql_notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}

# Labels
variable "cloudsql_labels" {
  description = "Labels for Cloud SQL resources"
  type        = map(string)
  default     = {}
}

# cloud run
variable "enable_cloudrun" {
  description = "Enable Cloud Run module"
  type        = bool
  default     = false
}

variable "cloudrun_service_name" {
  type    = string
  default = "my-cloudrun-service"
}

variable "cloudrun_image" {
  type    = string
  default = ""
}

variable "cloudrun_container_port" {
  type    = number
  default = 80
}

variable "cloudrun_memory" {
  type    = string
  default = "512Mi"
}

variable "cloudrun_cpu" {
  type    = string
  default = "1"
}

variable "cloudrun_concurrency" {
  type    = number
  default = 80
}

variable "cloudrun_max_instances" {
  type    = number
  default = 0
}

variable "cloudrun_min_instances" {
  type    = number
  default = 0
}

variable "cloudrun_env_vars" {
  type    = map(string)
  default = {}
}

variable "cloudrun_service_account_email" {
  type    = string
  default = null
}

variable "cloudrun_vpc_connector" {
  type    = string
  default = null
}

variable "cloudrun_ingress" {
  type    = string
  default = "ALLOW_ALL"
}

variable "cloudrun_allow_unauthenticated" {
  type    = bool
  default = true
}

variable "cloudrun_labels" {
  type    = map(string)
  default = {}
}

variable "cloudrun_timeout" {
  type    = string
  default = "300s"
}

variable "enable_cloudrun_cloudsql_connection" {
  description = "Toggle to connect Cloud Run service with Cloud SQL instance"
  type        = bool
  default     = false
}

# ═════════════════════════════════════════════════════════════════════════════
# LOAD BALANCER VARIABLES (GCP)
# ═════════════════════════════════════════════════════════════════════════════

variable "enable_load_balancer" {
  description = "Enable or disable the global HTTPS Load Balancer"
  type        = bool
  default     = false
}

variable "lb_name" {
  description = "Name prefix for the Load Balancer components"
  type        = string
  default     = "gcp-lb"
}

variable "lb_ssl_certificates" {
  description = "List of SSL certificate self_links"
  type        = list(string)
  default     = []
}

variable "lb_enable_cdn" {
  description = "Enable Cloud CDN on backend service"
  type        = bool
  default     = false
}

variable "lb_cloud_armor_policy" {
  description = "Cloud Armor security policy self_link"
  type        = string
  default     = null
}

variable "lb_negs" {
  description = "List of NEG (Network Endpoint Group) self_links for backend"
  type        = list(string)
  default     = []
}

variable "lb_instance_groups" {
  description = "List of Instance Group self_links for backend"
  type        = list(string)
  default     = []
}

variable "lb_backend_protocol" {
  description = "Backend protocol (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "lb_backend_timeout" {
  description = "Backend timeout in seconds"
  type        = number
  default     = 30
}

variable "lb_connection_draining_timeout" {
  description = "Connection draining timeout for backend service"
  type        = number
  default     = 30
}

# Listener Configuration
variable "lb_create_http_redirect" {
  description = "Create HTTP → HTTPS redirect listener"
  type        = bool
  default     = false
}

variable "lb_create_https_listener" {
  description = "Create HTTPS listener"
  type        = bool
  default     = false
}

# Health Check Configuration
variable "lb_health_check_port" {
  type    = number
  default = 80
}

variable "lb_health_check_path" {
  type    = string
  default = "/"
}

variable "lb_health_check_interval" {
  type    = number
  default = 30
}

variable "lb_health_check_timeout" {
  type    = number
  default = 5
}

variable "lb_health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "lb_health_check_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "environment" {
  type        = string
  description = "Environment name such as dev, staging, prod"
}

### ARTIFACT REGISTRY

variable "enable_artifact_registry" {
  type    = bool
  default = false
}

variable "artifact_registry_location" {
  type    = string
  default = "us-west1"
}

variable "artifact_registry_repository_id" {
  type    = string
  default = "my-artifact-repo"
}

variable "artifact_registry_format" {
  type    = string
  default = "DOCKER"
}

variable "artifact_registry_description" {
  type    = string
  default = ""
}

variable "artifact_registry_labels" {
  type    = map(string)
  default = {}
}

variable "artifact_registry_kms_key_name" {
  type    = string
  default = ""
}

variable "artifact_registry_enable_vulnerability_scanning" {
  type    = bool
  default = true
}

variable "artifact_registry_iam_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

# ═════════════════════════════════════════════════════════════════════════════
# MEMORYSTORE VARIABLES
# ═════════════════════════════════════════════════════════════════════════════

###############################################################################
# Memorystore Variables
###############################################################################

variable "enable_memorystore" {
  type        = bool
  default     = false
  description = "Enable Memorystore module"
}

variable "engine_type" {
  type        = string
  description = "Engine type: REDIS | REDIS_CLUSTER | MEMCACHED"
  default     = "REDIS"
}


variable "instance_id" {
  type        = string
  description = "Instance name for memorystore resource"
}

variable "display_name" {
  type    = string
  default = null
}

# Redis Classic
variable "tier" {
  type    = string
  default = "STANDARD_HA"
}

variable "memory_size_gb" {
  type    = number
  default = 1
}

variable "redis_version" {
  type    = string
  default = "REDIS_7_0"
}

variable "vpc_self_link" {
  type = string
}

variable "connect_mode" {
  type    = string
  default = "PRIVATE_SERVICE_ACCESS"
}

variable "transit_encryption_mode" {
  type    = string
  default = "SERVER_AUTHENTICATION"
}

variable "read_replicas_mode" {
  type    = string
  default = "DISABLED"
}

variable "replica_count" {
  type    = number
  default = 0
}

# Redis Cluster
variable "shard_count" {
  type    = number
  default = 3
}

variable "cluster_replica_count" {
  type    = number
  default = 1
}

variable "psc_networks" {
  type    = list(string)
  default = []
}

# Memcached
variable "memcached_node_count" {
  type    = number
  default = 1
}

variable "memcached_cpu" {
  type    = number
  default = 1
}

variable "memcached_memory_mb" {
  type    = number
  default = 1024
}

# Maintenance
variable "maintenance_day" {
  type    = string
  default = "SUNDAY"
}

variable "maintenance_start_hour" {
  type    = number
  default = 3
}

# Labels
variable "labels" {
  type    = map(string)
  default = {}
}

# ─────────────────────────────────────────────
# App Engine Root Module Variables
# ─────────────────────────────────────────────
# ─────────────────────────────────────────────
# CORE
# ─────────────────────────────────────────────

variable "enable_app_engine" {
  description = "Enable App Engine module"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────
# CONTROL CREATION / IMPORT
# ─────────────────────────────────────────────

variable "app_engine_enable_create_app" {
  description = "Create App Engine application if true"
  type        = bool
  default     = true
}

variable "app_engine_use_existing_app" {
  description = "Use existing App Engine application if true"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────
# APP ENGINE SERVICE SETTINGS
# ─────────────────────────────────────────────

variable "app_engine_service_name" {
  description = "App Engine service name (use 'default' for first deployment)"
  type        = string
  default     = "default"
}

variable "app_engine_version_label" {
  description = "Version label (example: v1, v2)"
  type        = string
  default     = "v1"
}

variable "app_engine_runtime" {
  description = "Runtime for Standard or Flex (example: python312)"
  type        = string
  default     = "python312"
}

variable "app_engine_environment_type" {
  description = "Environment type: standard or flex"
  type        = string
  default     = "standard"

  validation {
    condition     = var.app_engine_environment_type == "standard" || var.app_engine_environment_type == "flex"
    error_message = "app_engine_environment_type must be 'standard' or 'flex'."
  }
}

# ─────────────────────────────────────────────
# DEPLOYMENT SOURCES
# ─────────────────────────────────────────────

variable "app_engine_source_url" {
  description = "ZIP source URL for Standard deployments"
  type        = string
  default     = ""
}

variable "app_engine_container_image" {
  description = "Container image for Flex deployments"
  type        = string
  default     = ""
}

variable "app_engine_instance_class" {
  description = "Instance class for Standard runtime (e.g., F1, F2)"
  type        = string
  default     = "F1"
}

variable "app_engine_entrypoint_shell" {
  description = "Entrypoint command for Flex environment"
  type        = string
  default     = ""
}

# ─────────────────────────────────────────────
# ENVIRONMENT VARIABLES
# ─────────────────────────────────────────────

variable "app_engine_settings" {
  description = "Environment variables to expose inside App Engine"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# ─────────────────────────────────────────────
# TRAFFIC SPLITTING
# ─────────────────────────────────────────────

variable "app_engine_enable_split_traffic" {
  description = "Enable traffic split between versions"
  type        = bool
  default     = false
}

variable "app_engine_migrate_traffic" {
  description = "Automatically migrate 100% traffic to new version"
  type        = bool
  default     = true
}

variable "app_engine_split_shard_by" {
  description = "Traffic splitting method: UNSPECIFIED, COOKIE, IP, RANDOM"
  type        = string
  default     = "UNSPECIFIED"
}

# ─────────────────────────────────────────────
# PROTECTION
# ─────────────────────────────────────────────

variable "app_engine_prevent_destroy_versions" {
  description = "Prevents Terraform from deleting versions"
  type        = bool
  default     = false
}

variable "settings" {
  description = "Environment variables for the App Engine service"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "app_engine_tags" {
  description = "Tags/labels applied to all App Engine resources"
  type        = map(string)
  default     = {}
}

# ─────────────────────────────
# 🎮 GKE MODULE TOGGLE
# ─────────────────────────────
variable "enable_gke" {
  description = "Enable GKE cluster creation"
  type        = bool
  default     = false
}

variable "gke_create_node_pool" {
  description = "Create node pools for GKE"
  type        = bool
  default     = true
}

# ─────────────────────────────
# 🌐 BASIC CLUSTER CONFIGURATION
# ─────────────────────────────
variable "gke_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "primary-cluster"
}

variable "gke_cluster_location" {
  description = "Location (region or zone) for the GKE cluster"
  type        = string
  default     = ""
}

variable "gke_remove_default_node_pool" {
  description = "Remove default node pool on cluster creation"
  type        = bool
  default     = true
}

variable "gke_initial_node_count" {
  description = "Initial node count for default pool"
  type        = number
  default     = 1
}

variable "gke_min_master_version" {
  description = "Minimum master version"
  type        = string
  default     = null
}

variable "gke_deletion_protection" {
  description = "Enable deletion protection for cluster"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔗 NETWORKING CONFIGURATION
# ─────────────────────────────
variable "gke_network_self_link" {
  description = "VPC network self link (used when VPC module is disabled)"
  type        = string
  default     = ""
}

variable "gke_subnetwork_self_link" {
  description = "Subnetwork self link (used when VPC module is disabled)"
  type        = string
  default     = ""
}

variable "gke_networking_mode" {
  description = "Networking mode for GKE cluster"
  type        = string
  default     = "VPC_NATIVE"
}

variable "gke_cluster_secondary_range_name" {
  description = "Secondary range name for pods"
  type        = string
  default     = ""
}

variable "gke_services_secondary_range_name" {
  description = "Secondary range name for services"
  type        = string
  default     = ""
}

# ─────────────────────────────
# 🔒 PRIVATE CLUSTER CONFIGURATION
# ─────────────────────────────
variable "gke_enable_private_cluster" {
  description = "Enable private cluster"
  type        = bool
  default     = true
}

variable "gke_enable_private_nodes" {
  description = "Enable private nodes"
  type        = bool
  default     = true
}

variable "gke_enable_private_endpoint" {
  description = "Enable private endpoint"
  type        = bool
  default     = false
}

variable "gke_master_ipv4_cidr_block" {
  description = "CIDR block for master network"
  type        = string
  default     = "172.16.0.0/28"
}

variable "gke_enable_master_global_access" {
  description = "Enable global access to master"
  type        = bool
  default     = false
}

variable "gke_master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = optional(string)
  }))
  default = []
}

# ─────────────────────────────
# 🔐 SECURITY CONFIGURATION
# ─────────────────────────────
variable "gke_enable_workload_identity" {
  description = "Enable Workload Identity"
  type        = bool
  default     = true
}

variable "gke_enable_binary_authorization" {
  description = "Enable Binary Authorization"
  type        = bool
  default     = false
}

variable "gke_binary_authorization_evaluation_mode" {
  description = "Binary Authorization evaluation mode"
  type        = string
  default     = "PROJECT_SINGLETON_POLICY_ENFORCE"
}

variable "gke_enable_shielded_nodes" {
  description = "Enable Shielded GKE Nodes"
  type        = bool
  default     = true
}

variable "gke_enable_secure_boot" {
  description = "Enable Secure Boot"
  type        = bool
  default     = false
}

variable "gke_enable_integrity_monitoring" {
  description = "Enable Integrity Monitoring"
  type        = bool
  default     = true
}

variable "gke_enable_database_encryption" {
  description = "Enable database encryption"
  type        = bool
  default     = false
}

variable "gke_database_encryption_key_name" {
  description = "KMS key for database encryption"
  type        = string
  default     = ""
}

variable "gke_enable_security_posture" {
  description = "Enable security posture"
  type        = bool
  default     = false
}

variable "gke_security_posture_mode" {
  description = "Security posture mode"
  type        = string
  default     = "BASIC"
}

variable "gke_security_posture_vulnerability_mode" {
  description = "Vulnerability scanning mode"
  type        = string
  default     = "VULNERABILITY_DISABLED"
}

# ─────────────────────────────
# 🔌 ADDONS CONFIGURATION
# ─────────────────────────────
variable "gke_enable_http_load_balancing" {
  description = "Enable HTTP Load Balancing"
  type        = bool
  default     = true
}

variable "gke_enable_horizontal_pod_autoscaling" {
  description = "Enable Horizontal Pod Autoscaling"
  type        = bool
  default     = true
}

variable "gke_enable_vertical_pod_autoscaling" {
  description = "Enable Vertical Pod Autoscaling"
  type        = bool
  default     = false
}

variable "gke_enable_network_policy" {
  description = "Enable Network Policy"
  type        = bool
  default     = false
}

variable "gke_network_policy_provider" {
  description = "Network policy provider"
  type        = string
  default     = "PROVIDER_UNSPECIFIED"
}

variable "gke_enable_filestore_csi_driver" {
  description = "Enable Filestore CSI driver"
  type        = bool
  default     = false
}

variable "gke_enable_gcs_fuse_csi_driver" {
  description = "Enable GCS Fuse CSI driver"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔄 MAINTENANCE CONFIGURATION
# ─────────────────────────────
variable "gke_enable_maintenance_policy" {
  description = "Enable maintenance policy"
  type        = bool
  default     = true
}

variable "gke_maintenance_window_type" {
  description = "Maintenance window type"
  type        = string
  default     = "daily"
}

variable "gke_maintenance_start_time" {
  description = "Maintenance start time"
  type        = string
  default     = "03:00"
}

variable "gke_maintenance_recurrence_start_time" {
  description = "Recurring maintenance start time"
  type        = string
  default     = ""
}

variable "gke_maintenance_recurrence_end_time" {
  description = "Recurring maintenance end time"
  type        = string
  default     = ""
}

variable "gke_maintenance_recurrence" {
  description = "Maintenance recurrence rule"
  type        = string
  default     = ""
}

variable "gke_release_channel" {
  description = "GKE release channel"
  type        = string
  default     = "REGULAR"
}

# ─────────────────────────────
# 📊 MONITORING & LOGGING
# ─────────────────────────────
variable "gke_enable_monitoring_config" {
  description = "Enable monitoring configuration"
  type        = bool
  default     = true
}

variable "gke_monitoring_enable_components" {
  description = "Monitoring components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS"]
}

variable "gke_enable_managed_prometheus" {
  description = "Enable managed Prometheus"
  type        = bool
  default     = false
}

variable "gke_enable_logging_config" {
  description = "Enable logging configuration"
  type        = bool
  default     = true
}

variable "gke_logging_enable_components" {
  description = "Logging components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "gke_enable_resource_usage_export" {
  description = "Enable resource usage export"
  type        = bool
  default     = false
}

variable "gke_enable_network_egress_metering" {
  description = "Enable network egress metering"
  type        = bool
  default     = false
}

variable "gke_enable_resource_consumption_metering" {
  description = "Enable resource consumption metering"
  type        = bool
  default     = true
}

variable "gke_resource_usage_export_dataset_id" {
  description = "BigQuery dataset for usage export"
  type        = string
  default     = ""
}

# ─────────────────────────────
# 🎯 CLUSTER AUTOSCALING
# ─────────────────────────────
variable "gke_enable_cluster_autoscaling" {
  description = "Enable cluster autoscaling"
  type        = bool
  default     = false
}

variable "gke_autoscaling_profile" {
  description = "Autoscaling profile"
  type        = string
  default     = "BALANCED"
}

variable "gke_autoscaling_resource_limits" {
  description = "Autoscaling resource limits"
  type = list(object({
    resource_type = string
    minimum       = number
    maximum       = number
  }))
  default = []
}

# ─────────────────────────────
# 🖥️ NODE POOL CONFIGURATION
# ─────────────────────────────
variable "gke_node_pools" {
  description = "Node pool configurations"
  type        = any
  default     = {}
}

variable "gke_node_pool_initial_node_count" {
  description = "Initial node count per pool"
  type        = number
  default     = 1
}

variable "gke_node_pool_min_count" {
  description = "Minimum nodes per pool"
  type        = number
  default     = 1
}

variable "gke_node_pool_max_count" {
  description = "Maximum nodes per pool"
  type        = number
  default     = 3
}

variable "gke_node_pool_location_policy" {
  description = "Node pool location policy"
  type        = string
  default     = "BALANCED"
}

variable "gke_node_pool_machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_node_pool_disk_size_gb" {
  description = "Disk size for nodes"
  type        = number
  default     = 100
}

variable "gke_node_pool_disk_type" {
  description = "Disk type for nodes"
  type        = string
  default     = "pd-standard"
}

variable "gke_node_pool_image_type" {
  description = "Image type for nodes"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "gke_node_pool_preemptible" {
  description = "Use preemptible nodes"
  type        = bool
  default     = false
}

variable "gke_node_pool_spot" {
  description = "Use spot instances"
  type        = bool
  default     = false
}

variable "gke_node_service_account" {
  description = "Service account for nodes"
  type        = string
  default     = ""
}

variable "gke_node_oauth_scopes" {
  description = "OAuth scopes for nodes"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "gke_node_pool_labels" {
  description = "Labels for nodes"
  type        = map(string)
  default     = {}
}

variable "gke_node_pool_tags" {
  description = "Network tags for nodes"
  type        = list(string)
  default     = []
}

variable "gke_node_pool_metadata" {
  description = "Metadata for nodes"
  type        = map(string)
  default = {
    disable-legacy-endpoints = "true"
  }
}

variable "gke_enable_gcfs" {
  description = "Enable GCFS (image streaming)"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔧 NODE POOL MANAGEMENT
# ─────────────────────────────
variable "gke_auto_repair" {
  description = "Enable auto repair"
  type        = bool
  default     = true
}

variable "gke_auto_upgrade" {
  description = "Enable auto upgrade"
  type        = bool
  default     = true
}

variable "gke_enable_surge_upgrade" {
  description = "Enable surge upgrade"
  type        = bool
  default     = true
}

variable "gke_max_surge" {
  description = "Max surge during upgrade"
  type        = number
  default     = 1
}

variable "gke_max_unavailable" {
  description = "Max unavailable during upgrade"
  type        = number
  default     = 0
}

variable "gke_upgrade_strategy" {
  description = "Upgrade strategy"
  type        = string
  default     = "SURGE"
}

variable "gke_node_pool_soak_duration" {
  description = "Soak duration for blue-green"
  type        = string
  default     = "0s"
}

variable "gke_batch_percentage" {
  description = "Batch percentage for blue-green"
  type        = number
  default     = null
}

variable "gke_batch_node_count" {
  description = "Batch node count for blue-green"
  type        = number
  default     = null
}

variable "gke_batch_soak_duration" {
  description = "Batch soak duration"
  type        = string
  default     = "0s"
}

# ─────────────────────────────
# ⏱️ TIMEOUTS
# ─────────────────────────────
variable "gke_cluster_create_timeout" {
  description = "Cluster creation timeout"
  type        = string
  default     = "45m"
}

variable "gke_cluster_update_timeout" {
  description = "Cluster update timeout"
  type        = string
  default     = "45m"
}

variable "gke_cluster_delete_timeout" {
  description = "Cluster deletion timeout"
  type        = string
  default     = "45m"
}

variable "gke_node_pool_create_timeout" {
  description = "Node pool creation timeout"
  type        = string
  default     = "30m"
}

variable "gke_node_pool_update_timeout" {
  description = "Node pool update timeout"
  type        = string
  default     = "30m"
}

variable "gke_node_pool_delete_timeout" {
  description = "Node pool deletion timeout"
  type        = string
  default     = "30m"
}

variable "gke_pods_cidr_range" {
  description = "CIDR range for GKE pods secondary range"
  type        = string
  default     = "10.1.0.0/16"
}

variable "gke_services_cidr_range" {
  description = "CIDR range for GKE services secondary range"
  type        = string
  default     = "10.2.0.0/16"
}

##########################
# CDN Global toggles
##########################

variable "enable_cdn" {
  type    = bool
  default = false
}

variable "enable_cdn_https" {
  type    = bool
  default = false
}

variable "cdn_domains" {
  type    = list(string)
  default = []
}

##########################
# CDN ORIGIN SETTINGS
##########################

variable "cdn_origin_type" {
  description = "gcs or custom"
  type        = string
  default     = "gcs"
}

# GCS
variable "cdn_gcs_bucket_name" {
  type    = string
  default = null
}

# Custom backend (NEG or instance groups)
variable "cdn_backend_group" {
  type    = string
  default = null
}

variable "cdn_health_checks" {
  type    = list(string)
  default = []
}

variable "cdn_backend_protocol" {
  type    = string
  default = "HTTP"
}

variable "cdn_backend_timeout" {
  type    = number
  default = 30
}

##########################
# CDN cache behavior
##########################

variable "cdn_default_ttl" {
  type    = number
  default = 3600
}

variable "cdn_max_ttl" {
  type    = number
  default = 86400
}

variable "cdn_min_ttl" {
  type    = number
  default = 0
}

variable "cdn_forward_query_string" {
  type    = bool
  default = false
}

# Cloud Monitoring
variable "enable_cloud_monitoring" {
  type    = bool
  default = false
}

variable "monitoring_enable_log_bucket" {
  type    = bool
  default = false
}

variable "monitoring_log_bucket_id" {
  type    = string
  default = "custom-log-bucket"
}

variable "monitoring_log_retention_days" {
  type    = number
  default = 30
}

variable "monitoring_enable_alert" {
  type    = bool
  default = false
}

variable "monitoring_alert_name" {
  type    = string
  default = "High CPU Alert"
}

variable "monitoring_metric_display_name" {
  type    = string
  default = "CPU Utilization"
}

variable "monitoring_metric_filter" {
  type = string
}

variable "monitoring_comparison" {
  type    = string
  default = "COMPARISON_GT"
}

variable "monitoring_threshold_value" {
  type    = number
  default = 0.8
}

variable "monitoring_duration" {
  type    = number
  default = 300
}

variable "monitoring_alignment_period" {
  type    = number
  default = 120
}

variable "monitoring_per_series_aligner" {
  type    = string
  default = "ALIGN_MEAN"
}

variable "monitoring_notification_emails" {
  type    = list(string)
  default = []
}

variable "enable_analytics" {
  type    = bool
  default = false
}

# ═════════════════════════════════════════════════════════════════════════════
# IAM VARIABLES
# ═════════════════════════════════════════════════════════════════════════════

variable "iam_storage_admin_members" {
  description = "List of members to grant Storage Admin role"
  type        = list(string)
  default     = []
}

variable "iam_cloudsql_admin_members" {
  description = "List of members to grant Cloud SQL Admin role"
  type        = list(string)
  default     = []
}

variable "iam_monitoring_admin_members" {
  description = "List of members to grant Monitoring Admin role"
  type        = list(string)
  default     = []
}

variable "iam_logging_admin_members" {
  description = "List of members to grant Logging Admin role"
  type        = list(string)
  default     = []
}

variable "iam_lb_admin_members" {
  description = "List of members to grant Load Balancer Admin role"
  type        = list(string)
  default     = []
}

variable "iam_memorystore_admin_members" {
  description = "List of members to grant Memorystore Admin role"
  type        = list(string)
  default     = []
}

variable "gke_workload_identity_bindings" {
  description = "Map of GKE Workload Identity bindings"
  type = map(object({
    gcp_service_account_email = string
    k8s_namespace             = string
    k8s_service_account       = string
  }))
  default = {}
}

variable "custom_iam_bindings" {
  description = "Map of custom IAM bindings"
  type = map(object({
    role   = string
    member = string
    condition = optional(object({
      title       = string
      description = string
      expression  = string
    }))
  }))
  default = {}
}

variable "storage_admin_members" {
  type        = list(string)
  default     = []
  description = "Users/SA to grant Storage Admin role"
}

variable "storage_viewer_members" {
  type        = list(string)
  default     = []
  description = "Users/SA to grant Storage Object Viewer role"
}

variable "enable_storage_admin_bindings" {
  type        = bool
  default     = false
  description = "Enable storage IAM admin & viewer roles"
}

variable "enable_storage_viewer_bindings" {
  description = "Enable storage viewer IAM bindings"
  type        = bool
  default     = false
}

# ═════════════════════════════════════════════════════════════════════════════
# CLOUD SPANNER VARIABLES
# ═════════════════════════════════════════════════════════════════════════════

variable "enable_cloud_spanner" {
  type    = bool
  default = false
}

variable "spanner_instance_id" {
  type = string
}

variable "spanner_instance_config" {
  type = string
}

variable "spanner_num_nodes" {
  type    = number
  default = null
}

variable "spanner_processing_units" {
  type    = number
  default = null
}

variable "spanner_database_name" {
  type = string
}

variable "spanner_database_ddl" {
  type    = list(string)
  default = []
}

variable "spanner_labels" {
  type    = map(string)
  default = {}
}

variable "spanner_instance_iam_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

variable "spanner_database_iam_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}
