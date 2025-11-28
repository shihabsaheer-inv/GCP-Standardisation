# DEFAULT MODULES

locals {
  vpc      = var.enable_vpc ? module.vpc[0] : null
  storage  = var.enable_storage ? module.storage[0] : null
  cloudsql = var.enable_cloudsql ? module.cloudsql[0] : null
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# ─────────────────────────────
# 🌐 VPC Module
# ─────────────────────────────
module "vpc" {
  count                = var.enable_vpc ? 1 : 0
  source               = "../modules/vpc"
  project_id           = var.project_id
  enable_vpc           = var.enable_vpc
  region               = var.region
  vpc_name             = var.vpc_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs


  # Add these lines
  enable_gke_secondary_ranges = var.enable_gke
  gke_pods_range_name         = var.gke_cluster_secondary_range_name
  gke_pods_cidr_range         = var.gke_pods_cidr_range
  gke_services_range_name     = var.gke_services_secondary_range_name
  gke_services_cidr_range     = var.gke_services_cidr_range
}

# ─────────────────────────────
#  Compute Engine Module
# ─────────────────────────────
module "compute_engine" {
  count  = var.enable_compute_engine ? 1 : 0
  source = "../modules/compute_engine"

  # Toggles
  enable_compute_engine = var.enable_compute_engine

  # Project settings
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  # VM settings
  instance_count       = var.instance_count
  instance_name_prefix = var.instance_name_prefix
  instance_type        = var.instance_type
  boot_disk_size       = var.boot_disk_size
  boot_disk_type       = var.boot_disk_type
  image                = var.image

  # Networking (your module expects NAMES, not self-links)
  network_name    = var.enable_vpc ? module.vpc[0].vpc_self_link : "default"
  subnetwork_name = var.enable_vpc ? module.vpc[0].public_subnet_names[0] : "default"

  # IP settings
  associate_public_ip_address = var.associate_public_ip_address

  # IAM
  service_account_email = module.iam.compute_service_account_email

  # Naming
  use_sequential_naming = var.use_sequential_naming
  name_padding          = var.name_padding

  # Tags
  instance_tags = var.instance_tags

  # Start up script
  startup_scripts = {
    frontend = file("${path.root}/scripts/frontend.sh")
  }

  instance_roles = {
    0 = "frontend"
  }

  # Other
  deletion_protection = var.deletion_protection

  depends_on = [
    module.iam,
    module.vpc
  ]
}


# ─────────────────────────────
# 🗄️ Storage Module
# ─────────────────────────────
module "storage" {
  count                 = var.enable_storage ? 1 : 0
  source                = "../modules/storage"
  project_id            = var.project_id
  region                = var.region
  bucket_name           = var.storage_bucket_name
  force_destroy         = var.storage_force_destroy
  enable_versioning     = var.storage_enable_versioning
  enable_static_website = var.storage_enable_static_website
  index_document        = var.storage_index_document
  error_document        = var.storage_error_document
  enable_public_access  = var.storage_enable_public_access
  public_access_members = var.storage_public_access_members
  labels                = var.storage_labels
}


# ─────────────────────────────
# 🔥 Firewall Module
# ─────────────────────────────
module "firewall" {
  count                  = var.enable_vpc ? 1 : 0
  source                 = "../modules/firewall"
  enable_firewall        = var.enable_firewall
  network_self_link      = module.vpc[0].network_self_link
  vpc_name               = var.vpc_name
  internal_source_ranges = concat(var.public_subnet_cidrs, var.private_subnet_cidrs)

  depends_on = [module.vpc]
}

# ─────────────────────────────
# 🗃️ Cloud SQL Module
# ─────────────────────────────
module "cloudsql" {
  count  = var.enable_cloudsql ? 1 : 0
  source = "../modules/cloud_sql"

  create_instance   = var.enable_cloudsql
  project_id        = var.project_id
  region            = var.region
  instance_name     = var.cloudsql_instance_name
  database_version  = var.cloudsql_database_version
  tier              = var.cloudsql_tier
  availability_type = var.cloudsql_availability_type

  disk_type             = var.cloudsql_disk_type
  disk_size             = var.cloudsql_disk_size
  disk_autoresize       = var.cloudsql_disk_autoresize
  disk_autoresize_limit = var.cloudsql_disk_autoresize_limit

  backup_enabled                 = var.cloudsql_backup_enabled
  backup_start_time              = var.cloudsql_backup_start_time
  point_in_time_recovery_enabled = var.cloudsql_point_in_time_recovery_enabled
  transaction_log_retention_days = var.cloudsql_transaction_log_retention_days
  retained_backups               = var.cloudsql_retained_backups

  ipv4_enabled        = var.cloudsql_ipv4_enabled
  private_network     = var.enable_vpc ? module.vpc[0].network_self_link : null
  require_ssl         = var.cloudsql_require_ssl
  authorized_networks = var.cloudsql_authorized_networks

  labels = var.cloudsql_labels

  depends_on = [module.vpc]
}

# ─────────────────────────────
# 🔐 Cloud Run ↔ Cloud SQL IAM Binding
# ─────────────────────────────
resource "google_project_iam_member" "cloudrun_sql_client" {
  count   = var.enable_cloudrun && var.enable_cloudsql && var.enable_cloudrun_cloudsql_connection ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.cloudrun_service_account_email}"

  depends_on = [module.cloudsql]
}

# ─────────────────────────────
# ☁️ Cloud Run Module
# ─────────────────────────────
module "cloud_run" {
  count                 = var.enable_cloudrun ? 1 : 0
  source                = "../modules/cloud_run"
  create                = var.enable_cloudrun
  project_id            = var.project_id
  region                = var.region
  name                  = var.cloudrun_service_name
  image                 = var.cloudrun_image
  port                  = var.cloudrun_container_port
  memory                = var.cloudrun_memory
  cpu                   = var.cloudrun_cpu
  concurrency           = var.cloudrun_concurrency
  max_instances         = var.cloudrun_max_instances
  min_instances         = var.cloudrun_min_instances
  env_vars              = var.cloudrun_env_vars
  service_account_email = var.cloudrun_service_account_email
  vpc_connector         = var.cloudrun_vpc_connector
  ingress               = var.cloudrun_ingress
  allow_unauthenticated = var.cloudrun_allow_unauthenticated
  labels                = var.cloudrun_labels
  timeout               = var.cloudrun_timeout

  # 👇 New Cloud SQL Connection Support
  enable_cloudsql_connection = var.enable_cloudrun_cloudsql_connection
  cloudsql_connection_name   = var.enable_cloudrun_cloudsql_connection && var.enable_cloudsql ? module.cloudsql[0].instance_connection_name : null



  depends_on = [
    module.cloudsql,
    google_project_iam_member.cloudrun_sql_client
  ]
}

###############################################################################
#  LOADBALANCER MODULE
###############################################################################

module "load_balancer" {
  count  = var.enable_load_balancer ? 1 : 0
  source = "../modules/load_balancer"

  create_lb = var.enable_load_balancer
  lb_name   = var.lb_name
  lb_instance_groups = flatten([
    for m in module.compute_engine : m.instance_group_self_links
  ])


  # Listener toggles (MUST be passed!!)
  create_https_listener = var.lb_create_https_listener
  create_http_redirect  = var.lb_create_http_redirect

  # SSL certificates
  ssl_certificates = var.lb_ssl_certificates

  # Backends
  negs            = var.lb_negs
  instance_groups = var.lb_instance_groups

  # CDN + WAF
  enable_cdn         = var.lb_enable_cdn
  cloud_armor_policy = var.lb_cloud_armor_policy

  # Backend configs
  backend_protocol            = var.lb_backend_protocol
  backend_timeout             = var.lb_backend_timeout
  connection_draining_timeout = var.lb_connection_draining_timeout
  

  # Health check configs
  health_check_port                = var.lb_health_check_port
  health_check_path                = var.lb_health_check_path
  health_check_interval            = var.lb_health_check_interval
  health_check_timeout             = var.lb_health_check_timeout
  health_check_healthy_threshold   = var.lb_health_check_healthy_threshold
  health_check_unhealthy_threshold = var.lb_health_check_unhealthy_threshold
}

###############################################################################
#  ARTIFACT REGISTRY MODULE
###############################################################################

module "artifact_registry" {
  count  = var.enable_artifact_registry ? 1 : 0
  source = "../modules/artifact_registry"

  create_repo                   = var.enable_artifact_registry
  project_id                    = var.project_id
  location                      = var.artifact_registry_location
  repository_id                 = var.artifact_registry_repository_id
  format                        = var.artifact_registry_format
  description                   = var.artifact_registry_description
  labels                        = var.artifact_registry_labels
  kms_key_name                  = var.artifact_registry_kms_key_name
  enable_vulnerability_scanning = var.artifact_registry_enable_vulnerability_scanning

  iam_bindings = var.artifact_registry_iam_bindings
}

###############################################################################
# Memorystore Module
###############################################################################

module "memorystore" {
  source = "../modules/memorystore"

  # Enable/Disable
  enable_memorystore = var.enable_memorystore

  # Engine type (REDIS | REDIS_CLUSTER | MEMCACHED)
  engine_type = var.engine_type

  # Common fields
  project_id   = var.project_id
  instance_id  = var.instance_id
  display_name = var.display_name
  region       = var.region

  # Redis Classic
  tier                    = var.tier
  memory_size_gb          = var.memory_size_gb
  redis_version           = var.redis_version
  vpc_self_link           = var.vpc_self_link
  connect_mode            = var.connect_mode
  transit_encryption_mode = var.transit_encryption_mode
  read_replicas_mode      = var.read_replicas_mode
  replica_count           = var.replica_count

  # Redis Cluster
  shard_count           = var.shard_count
  cluster_replica_count = var.cluster_replica_count
  psc_networks          = var.psc_networks

  # Memcached
  memcached_node_count = var.memcached_node_count
  memcached_cpu        = var.memcached_cpu
  memcached_memory_mb  = var.memcached_memory_mb

  # Maintenance
  maintenance_day        = var.maintenance_day
  maintenance_start_hour = var.maintenance_start_hour

  # Labels
  labels = var.labels
}

# ─────────────────────────────
# 🚀 App Engine Module (Standard/Flex)
# ─────────────────────────────
module "app_engine" {
  source = "../modules/app_engine"
  count  = var.enable_app_engine ? 1 : 0

  # core
  project_id  = var.project_id
  location_id = var.region

  # control creation/import
  enable_create_app       = var.app_engine_enable_create_app
  enable_use_existing_app = var.app_engine_use_existing_app

  service_name     = var.app_engine_service_name
  version_label    = var.app_engine_version_label
  runtime          = var.app_engine_runtime
  environment_type = var.app_engine_environment_type

  source_url       = var.app_engine_source_url
  container_image  = var.app_engine_container_image
  instance_class   = var.app_engine_instance_class
  entrypoint_shell = var.app_engine_entrypoint_shell

  settings = var.app_engine_settings

  enable_split_traffic = var.app_engine_enable_split_traffic
  migrate_traffic      = var.app_engine_migrate_traffic
  split_shard_by       = var.app_engine_split_shard_by

  prevent_destroy_versions = var.app_engine_prevent_destroy_versions
}

# ─────────────────────────────
# 🎯 GKE Module
# ─────────────────────────────
module "gke" {
  count  = var.enable_gke ? 1 : 0
  source = "../modules/gke"

  gke_network_self_link    = module.vpc[0].vpc_self_link
  gke_subnetwork_self_link = module.vpc[0].private_subnet_self_links[0]

  # Control
  create_cluster   = var.enable_gke
  create_node_pool = var.gke_create_node_pool

  # Basic Configuration
  project_id       = var.project_id
  cluster_name     = var.gke_cluster_name
  cluster_location = var.gke_cluster_location

  remove_default_node_pool = var.gke_remove_default_node_pool
  initial_node_count       = var.gke_initial_node_count
  min_master_version       = var.gke_min_master_version
  deletion_protection      = var.gke_deletion_protection

  # Networking

  network_self_link             = var.enable_vpc ? module.vpc[0].network_self_link : var.gke_network_self_link
  subnetwork_self_link          = var.enable_vpc ? module.vpc[0].public_subnet_self_links[0] : var.gke_subnetwork_self_link
  networking_mode               = var.gke_networking_mode
  cluster_secondary_range_name  = var.gke_cluster_secondary_range_name
  services_secondary_range_name = var.gke_services_secondary_range_name

  # Private Cluster
  enable_private_cluster      = var.gke_enable_private_cluster
  enable_private_nodes        = var.gke_enable_private_nodes
  enable_private_endpoint     = var.gke_enable_private_endpoint
  master_ipv4_cidr_block      = var.gke_master_ipv4_cidr_block
  enable_master_global_access = var.gke_enable_master_global_access
  master_authorized_networks  = var.gke_master_authorized_networks

  # Security
  enable_workload_identity             = var.gke_enable_workload_identity
  enable_binary_authorization          = var.gke_enable_binary_authorization
  binary_authorization_evaluation_mode = var.gke_binary_authorization_evaluation_mode
  enable_shielded_nodes                = var.gke_enable_shielded_nodes
  enable_secure_boot                   = var.gke_enable_secure_boot
  enable_integrity_monitoring          = var.gke_enable_integrity_monitoring
  enable_database_encryption           = var.gke_enable_database_encryption
  database_encryption_key_name         = var.gke_database_encryption_key_name
  enable_security_posture              = var.gke_enable_security_posture
  security_posture_mode                = var.gke_security_posture_mode
  security_posture_vulnerability_mode  = var.gke_security_posture_vulnerability_mode

  # Addons
  enable_http_load_balancing        = var.gke_enable_http_load_balancing
  enable_horizontal_pod_autoscaling = var.gke_enable_horizontal_pod_autoscaling
  enable_vertical_pod_autoscaling   = var.gke_enable_vertical_pod_autoscaling
  enable_network_policy             = var.gke_enable_network_policy
  network_policy_provider           = var.gke_network_policy_provider
  enable_filestore_csi_driver       = var.gke_enable_filestore_csi_driver
  enable_gcs_fuse_csi_driver        = var.gke_enable_gcs_fuse_csi_driver

  # Maintenance
  enable_maintenance_policy         = var.gke_enable_maintenance_policy
  maintenance_window_type           = var.gke_maintenance_window_type
  maintenance_start_time            = var.gke_maintenance_start_time
  maintenance_recurrence_start_time = var.gke_maintenance_recurrence_start_time
  maintenance_recurrence_end_time   = var.gke_maintenance_recurrence_end_time
  maintenance_recurrence            = var.gke_maintenance_recurrence
  release_channel                   = var.gke_release_channel

  # Monitoring & Logging
  enable_monitoring_config             = var.gke_enable_monitoring_config
  monitoring_enable_components         = var.gke_monitoring_enable_components
  enable_managed_prometheus            = var.gke_enable_managed_prometheus
  enable_logging_config                = var.gke_enable_logging_config
  logging_enable_components            = var.gke_logging_enable_components
  enable_resource_usage_export         = var.gke_enable_resource_usage_export
  enable_network_egress_metering       = var.gke_enable_network_egress_metering
  enable_resource_consumption_metering = var.gke_enable_resource_consumption_metering
  resource_usage_export_dataset_id     = var.gke_resource_usage_export_dataset_id

  # Cluster Autoscaling
  enable_cluster_autoscaling  = var.gke_enable_cluster_autoscaling
  autoscaling_profile         = var.gke_autoscaling_profile
  autoscaling_resource_limits = var.gke_autoscaling_resource_limits

  # Node Pools
  node_pools                   = var.gke_node_pools
  node_pool_initial_node_count = var.gke_node_pool_initial_node_count
  node_pool_min_count          = var.gke_node_pool_min_count
  node_pool_max_count          = var.gke_node_pool_max_count
  node_pool_location_policy    = var.gke_node_pool_location_policy
  node_pool_machine_type       = var.gke_node_pool_machine_type
  node_pool_disk_size_gb       = var.gke_node_pool_disk_size_gb
  node_pool_disk_type          = var.gke_node_pool_disk_type
  node_pool_image_type         = var.gke_node_pool_image_type
  node_pool_preemptible        = var.gke_node_pool_preemptible
  node_pool_spot               = var.gke_node_pool_spot
  node_service_account         = var.gke_node_service_account
  node_oauth_scopes            = var.gke_node_oauth_scopes
  node_pool_labels             = var.gke_node_pool_labels
  node_pool_tags               = var.gke_node_pool_tags
  node_pool_metadata           = var.gke_node_pool_metadata
  enable_gcfs                  = var.gke_enable_gcfs

  # Node Pool Management
  auto_repair             = var.gke_auto_repair
  auto_upgrade            = var.gke_auto_upgrade
  enable_surge_upgrade    = var.gke_enable_surge_upgrade
  max_surge               = var.gke_max_surge
  max_unavailable         = var.gke_max_unavailable
  upgrade_strategy        = var.gke_upgrade_strategy
  node_pool_soak_duration = var.gke_node_pool_soak_duration
  batch_percentage        = var.gke_batch_percentage
  batch_node_count        = var.gke_batch_node_count
  batch_soak_duration     = var.gke_batch_soak_duration

  # Timeouts
  cluster_create_timeout   = var.gke_cluster_create_timeout
  cluster_update_timeout   = var.gke_cluster_update_timeout
  cluster_delete_timeout   = var.gke_cluster_delete_timeout
  node_pool_create_timeout = var.gke_node_pool_create_timeout
  node_pool_update_timeout = var.gke_node_pool_update_timeout
  node_pool_delete_timeout = var.gke_node_pool_delete_timeout

  depends_on = [module.vpc]
}


##############################
# CLOUD CDN MODULE 
##############################
##############################
# Global IP (Optional for HTTPS)
##############################
resource "google_compute_global_address" "cdn_ip" {
  count = var.enable_cdn && var.enable_cdn_https ? 1 : 0

  name = "${var.environment}-cdn-ip"
}

##############################
# SSL Certificate (Optional)
##############################
resource "google_compute_managed_ssl_certificate" "cdn_cert" {
  count = var.enable_cdn && var.enable_cdn_https && length(var.cdn_domains) > 0 ? 1 : 0

  name = "${var.environment}-cdn-cert"

  managed {
    domains = var.cdn_domains
  }
}

##############################
# CLOUD CDN MODULE CALL
##############################

module "cloud_cdn" {
  source = "../modules/cloud_cdn"

  name        = "${var.environment}-cdn"
  enable_cdn  = var.enable_cdn
  origin_type = var.cdn_origin_type

  # GCS backend
  gcs_bucket_name = var.cdn_gcs_bucket_name

  # Custom backend (NEG / MIG / Instance Group)
  backend_group    = var.cdn_backend_group
  health_checks    = var.cdn_health_checks
  backend_protocol = var.cdn_backend_protocol
  backend_timeout  = var.cdn_backend_timeout

  # CDN cache params
  default_ttl = var.cdn_default_ttl
  max_ttl     = var.cdn_max_ttl
  min_ttl     = var.cdn_min_ttl

  forward_query_string = var.cdn_forward_query_string

  # HTTPS LB
  enable_https     = var.enable_cdn_https
  ssl_certificates = google_compute_managed_ssl_certificate.cdn_cert[*].self_link
  global_ip        = try(google_compute_global_address.cdn_ip[0].address, null)
}

# ─────────────────────────────
# 📊 Cloud Monitoring Module
# ─────────────────────────────
module "cloud_monitoring" {
  count  = var.enable_cloud_monitoring ? 1 : 0
  source = "../modules/cloud_monitoring"

  enable_monitoring = var.enable_cloud_monitoring

  project_id = var.project_id
  location   = var.region

  # Logging
  enable_log_bucket  = var.monitoring_enable_log_bucket
  log_bucket_id      = var.monitoring_log_bucket_id
  log_retention_days = var.monitoring_log_retention_days

  # Alerts
  enable_alert        = var.monitoring_enable_alert
  alert_name          = var.monitoring_alert_name
  metric_display_name = var.monitoring_metric_display_name
  metric_filter       = var.monitoring_metric_filter
  comparison          = var.monitoring_comparison
  threshold_value     = var.monitoring_threshold_value
  duration            = var.monitoring_duration
  alignment_period    = var.monitoring_alignment_period
  per_series_aligner  = var.monitoring_per_series_aligner

  # Notification
  notification_emails = var.monitoring_notification_emails
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 IAM Module
# ─────────────────────────────────────────────────────────────────────────────
module "iam" {
  source = "../modules/iam"

  project_id             = var.project_id
  service_account_prefix = var.environment

  # Service Account Creation Toggles (Only create if the service is enabled)
  enable_cloudrun_sa          = var.enable_cloudrun
  enable_compute_sa           = var.enable_compute_engine
  enable_gke_node_sa          = var.enable_gke
  enable_cloudsql_client_sa   = var.enable_cloudsql
  enable_app_engine_sa        = var.enable_app_engine
  enable_artifact_registry_sa = var.enable_artifact_registry
  enable_memorystore_sa       = var.enable_memorystore

  # Cloud Run Permissions
  grant_cloudrun_cloudsql_access          = var.enable_cloudrun && var.enable_cloudsql && var.enable_cloudrun_cloudsql_connection
  grant_cloudrun_storage_access           = var.enable_cloudrun && var.enable_storage
  grant_cloudrun_secret_access            = var.enable_cloudrun
  grant_cloudrun_memorystore_access       = var.enable_cloudrun && var.enable_memorystore
  grant_cloudrun_artifact_registry_access = var.enable_cloudrun && var.enable_artifact_registry
  grant_cloudrun_vpc_access               = var.enable_cloudrun && var.enable_vpc

  # Compute Engine Permissions
  grant_compute_cloudsql_access          = var.enable_compute_engine && var.enable_cloudsql
  grant_compute_storage_access           = var.enable_compute_engine && var.enable_storage
  grant_compute_artifact_registry_access = var.enable_compute_engine && var.enable_artifact_registry

  # GKE Permissions
  grant_gke_storage_access           = var.enable_gke && var.enable_storage
  grant_gke_artifact_registry_access = var.enable_gke && var.enable_artifact_registry
  grant_gke_cloudsql_access          = var.enable_gke && var.enable_cloudsql
  grant_gke_memorystore_access       = var.enable_gke && var.enable_memorystore

  # App Engine Permissions
  grant_appengine_storage_access     = var.enable_app_engine && var.enable_storage
  grant_appengine_cloudsql_access    = var.enable_app_engine && var.enable_cloudsql
  grant_appengine_memorystore_access = var.enable_app_engine && var.enable_memorystore
  grant_appengine_vpc_access         = var.enable_app_engine && var.enable_vpc

  # Artifact Registry Permissions
  grant_cloudbuild_artifact_registry_access = var.enable_artifact_registry

  # CDN Permissions
  grant_cdn_storage_access = var.enable_cdn && var.enable_storage

  # KMS Bindings
  enable_cloudsql_kms_binding = var.enable_cloudsql && var.cloudsql_create_kms_key
  kms_crypto_key_id           = var.enable_cloudsql && var.cloudsql_create_kms_key ? module.cloudsql[0].kms_crypto_key_id : ""

  enable_gke_kms_binding = var.enable_gke && var.gke_enable_database_encryption
  gke_kms_crypto_key_id  = var.gke_enable_database_encryption ? var.gke_database_encryption_key_name : ""

  # ⚠️ IMPORTANT: Admin IAM Bindings Toggles (Only create if resource is enabled)
  enable_storage_admin_bindings     = var.enable_storage_admin_bindings
  enable_cloudsql_admin_bindings    = var.enable_cloudsql
  enable_monitoring_admin_bindings  = var.enable_cloud_monitoring
  enable_logging_admin_bindings     = var.enable_cloud_monitoring
  enable_lb_admin_bindings          = var.enable_load_balancer
  enable_memorystore_admin_bindings = var.enable_memorystore
  storage_viewer_members            = var.storage_viewer_members
  enable_storage_viewer_bindings    = var.enable_storage_viewer_bindings


  # Admin Members (Only applied if corresponding resource is enabled)
  storage_admin_members     = var.storage_admin_members
  cloudsql_admin_members    = var.iam_cloudsql_admin_members
  monitoring_admin_members  = var.iam_monitoring_admin_members
  logging_admin_members     = var.iam_logging_admin_members
  lb_admin_members          = var.iam_lb_admin_members
  memorystore_admin_members = var.iam_memorystore_admin_members

  # GKE Workload Identity (if using)
  gke_workload_identity_bindings = var.gke_workload_identity_bindings

  # Custom IAM bindings (optional)
  custom_iam_bindings = var.custom_iam_bindings
}