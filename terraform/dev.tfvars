# ═════════════════════════════════════════════════════════════════════════════
# COMMON VARIABLES
# ═════════════════════════════════════════════════════════════════════════════
region      = "us-west1"
project_id  = "terraform-setup-476004"
zone        = "us-west1-a"
environment = "dev"

# ═════════════════════════════════════════════════════════════════════════════
# MODULE TOGGLES
# ═════════════════════════════════════════════════════════════════════════════
enable_vpc                          = false # Set to true to enable VPC
enable_compute_engine               = false # Set to true to enable Compute Engine
enable_firewall                     = false # Set to true to enable Firewall
enable_storage                      = false # Set to true to enable Cloud Storage
enable_cloudsql                     = false # Set to true to enable Cloud SQL
enable_cloud_spanner                = true  # Set to true to enable Cloud Spanner
enable_cloudrun                     = false # Set to true to enable Cloud Run
enable_cloudrun_cloudsql_connection = false # Set to true to enable Cloud SQL & Cloud Run connection
enable_load_balancer                = false # Set to true to enable Cloud LoadBalancer
enable_artifact_registry            = false # Set to true to enable Artifact Registry
enable_memorystore                  = false # Set to true to enable Memory Store
enable_app_engine                   = false # Set to true to enable App Engine
enable_gke                          = false # Set to true to enable GKE
enable_cdn                          = false # Set to true to enable Cloud CDN
enable_cdn_https                    = false # Set to true to enable HTTPS CDN
enable_cloud_monitoring             = false # Set to true to enable Cloud Monitoring

# ═════════════════════════════════════════════════════════════════════════════
# IAM CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# 👥 IAM ADMIN MEMBERS
# Add your user emails, service accounts, or groups here
# Format: "user:email@example.com" or "group:group@example.com"
# ─────────────────────────────────────────────────────────────────────────────

# Storage Administrators (full control over GCS buckets)
/*
iam_storage_admin_members = [
  "user:"
  # "group:devops-team@example.com"
  # "serviceAccount:admin-sa@terraform-setup-476004.iam.gserviceaccount.com"
]
*/

# Cloud SQL Administrators (manage database instances)
iam_cloudsql_admin_members = [
  "user:"
  # "group:database-admins@example.com"
]

# Monitoring Administrators (manage alerts and dashboards)
iam_monitoring_admin_members = [
  "user:"
  # "group:sre-team@example.com"
]

# Logging Administrators (manage log sinks and retention)
iam_logging_admin_members = [
  "user:"
  # "group:security-team@example.com"
]

# Load Balancer Administrators (manage LB configurations)
iam_lb_admin_members = [
  "user:"
  # "group:network-team@example.com"
]

# Memorystore Administrators (manage Redis/Memcached instances)
iam_memorystore_admin_members = [
  "user:"
  # "group:backend-team@example.com"
]

# ─────────────────────────────────────────────────────────────────────────────
# ☸️ GKE WORKLOAD IDENTITY BINDINGS
# Maps Kubernetes Service Accounts to GCP Service Accounts
# ─────────────────────────────────────────────────────────────────────────────

gke_workload_identity_bindings = {
  # Example: Backend application needs Cloud SQL access
  # "backend-app" = {
  #   gcp_service_account_email = "sa-cloudsql-client@terraform-setup-476004.iam.gserviceaccount.com"
  #   k8s_namespace             = "production"
  #   k8s_service_account       = "backend-sa"
  # }

  # Example: Frontend application needs Storage access
  # "frontend-app" = {
  #   gcp_service_account_email = "sa-cloudrun@terraform-setup-476004.iam.gserviceaccount.com"
  #   k8s_namespace             = "production"
  #   k8s_service_account       = "frontend-sa"
  # }

  # Example: Worker jobs need Memorystore access
  # "worker-jobs" = {
  #   gcp_service_account_email = "sa-memorystore@terraform-setup-476004.iam.gserviceaccount.com"
  #   k8s_namespace             = "jobs"
  #   k8s_service_account       = "worker-sa"
  # }
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 CUSTOM IAM BINDINGS
# Add any custom IAM role assignments here
# ─────────────────────────────────────────────────────────────────────────────

custom_iam_bindings = {
  # Example: Grant a developer read-only access
  # "developer-viewer" = {
  #   role   = "roles/viewer"
  #   member = "user:developer@example.com"
  #   condition = null
  # }

  # Example: Grant CI/CD service account deployment permissions
  # "cicd-deployer" = {
  #   role   = "roles/run.admin"
  #   member = "serviceAccount:cicd@terraform-setup-476004.iam.gserviceaccount.com"
  #   condition = null
  # }

  # Example: Conditional access (only during business hours)
  # "business-hours-access" = {
  #   role   = "roles/compute.instanceAdmin.v1"
  #   member = "user:contractor@example.com"
  #   condition = {
  #     title       = "Business Hours Only"
  #     description = "Access only during 9 AM to 5 PM PST"
  #     expression  = "request.time.getHours(\"America/Los_Angeles\") >= 9 && request.time.getHours(\"America/Los_Angeles\") < 17"
  #   }
  # }
}

# ═════════════════════════════════════════════════════════════════════════════
# VPC CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
vpc_name                = "dev-vpc-new"
public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs    = ["10.0.10.0/24", "10.0.11.0/24"]
gke_pods_cidr_range     = "10.1.0.0/16" # ~65k IPs for pods
gke_services_cidr_range = "10.2.0.0/16" # ~65k IPs for services

# ═════════════════════════════════════════════════════════════════════════════
# COMPUTE ENGINE CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
instance_count              = 1
instance_name_prefix        = "dev-instance"
boot_disk_size              = 10
instance_type               = "e2-medium"
boot_disk_type              = "pd-ssd"
image                       = "projects/debian-cloud/global/images/family/debian-12"
associate_public_ip_address = false
# NOTE: This will be replaced by IAM module output
service_account_email = "" # Leave empty - will use module.iam.compute_service_account_email
instance_tags         = ["allow-http", "allow-ssh"]
use_sequential_naming = true
name_padding          = 1


# ═════════════════════════════════════════════════════════════════════════════
# FIREWALL CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
ssh_source_ranges = ["0.0.0.0/0"] # Restrict to your IP for security

# ═════════════════════════════════════════════════════════════════════════════
# STORAGE CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
storage_bucket_name           = "dev-static-site-terraform-setup-476004"
storage_force_destroy         = false
storage_enable_versioning     = false
storage_enable_static_website = true
storage_index_document        = "index.html"
storage_error_document        = "404.html"
storage_enable_public_access  = false
storage_public_access_members = ["allUsers"]
storage_labels = {
  environment = "dev"
  team        = "devops"
}

enable_storage_admin_bindings  = false
enable_storage_viewer_bindings = false

storage_admin_members = [
  "user:"
]

storage_viewer_members = [
  "user:"
]
# ═════════════════════════════════════════════════════════════════════════════
# CLOUD SQL CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════

# General Configuration
cloudsql_instance_name     = "dev-cloudsql-instance"
cloudsql_database_version  = "MYSQL_8_0"   # Options: MYSQL_8_0, POSTGRES_15, SQLSERVER_2019_STANDARD
cloudsql_tier              = "db-f1-micro" # db-f1-micro (shared), db-g1-small (shared), db-n1-standard-1 (dedicated)
cloudsql_availability_type = "ZONAL"       # ZONAL (single zone) or REGIONAL (high availability)

# Storage Configuration
cloudsql_disk_type             = "PD_SSD" # PD_SSD (faster) or PD_HDD (cheaper)
cloudsql_disk_size             = 10
cloudsql_disk_autoresize       = true
cloudsql_disk_autoresize_limit = 100

# Backup Configuration
cloudsql_backup_enabled                 = true
cloudsql_backup_start_time              = "03:00"
cloudsql_point_in_time_recovery_enabled = false # Requires binary logging (extra cost)
cloudsql_transaction_log_retention_days = 7
cloudsql_retained_backups               = 7

# Network Configuration
cloudsql_ipv4_enabled = false # Set to true for public IP (not recommended for production)
cloudsql_require_ssl  = true
cloudsql_authorized_networks = [
  # {
  #   name  = "office-network"
  #   value = "203.0.113.0/24"
  # }
]

# Maintenance Configuration
cloudsql_maintenance_window_day          = 7        # 1 = Monday, 7 = Sunday
cloudsql_maintenance_window_hour         = 5        # 0-23
cloudsql_maintenance_window_update_track = "stable" # stable or canary

# Database Flags (MySQL Example)
cloudsql_database_flags = [
  {
    name  = "max_connections"
    value = "100"
  },
  {
    name  = "slow_query_log"
    value = "on"
  }
]

# Query Insights
cloudsql_query_insights_enabled  = true
cloudsql_query_string_length     = 1024
cloudsql_record_application_tags = false
cloudsql_record_client_address   = false

# Password Policy
cloudsql_enable_password_policy            = false
cloudsql_password_policy_min_length        = 12
cloudsql_password_policy_complexity        = "COMPLEXITY_DEFAULT"
cloudsql_password_policy_reuse_interval    = 5
cloudsql_password_policy_disallow_username = true

# Security
cloudsql_deletion_protection     = false # Set to true for production
cloudsql_create_kms_key          = true
cloudsql_kms_key_rotation_period = "7776000s" # 90 days
cloudsql_create_service_account  = false

# Databases to Create
cloudsql_databases = {
  app_db = {
    name      = "application_db"
    charset   = "utf8mb4"
    collation = "utf8mb4_unicode_ci"
  }
}

# Users to Create
cloudsql_users = {
  app_user = {
    name                   = "app_user"
    password               = null # Will be auto-generated
    host                   = "%"
    enable_password_policy = true
  }
}

cloudsql_generate_random_password = true

# Read Replicas
cloudsql_create_read_replica         = false
cloudsql_replica_count               = 1
cloudsql_replica_tier                = null # Defaults to main instance tier
cloudsql_replica_region              = null # Defaults to main instance region
cloudsql_replica_availability_type   = "ZONAL"
cloudsql_replica_ipv4_enabled        = false
cloudsql_replica_failover_target     = false
cloudsql_replica_deletion_protection = false

# Monitoring and Alerts
cloudsql_create_monitoring_alerts     = true
cloudsql_cpu_utilization_threshold    = 80
cloudsql_memory_utilization_threshold = 80
cloudsql_disk_utilization_threshold   = 80
cloudsql_connections_threshold        = 80
cloudsql_alert_evaluation_period      = 300
cloudsql_notification_channels        = [] # Add notification channel IDs here

# Labels
cloudsql_labels = {
  environment = "dev"
  team        = "backend"
  managed_by  = "terraform"
  service     = "database"
}

# ═════════════════════════════════════════════════════════════════════════════
# CLOUD RUN CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
cloudrun_service_name          = "dev-myapp"
cloudrun_image                 = "nginx:latest"
cloudrun_memory                = "512Mi"
cloudrun_cpu                   = "1"
cloudrun_concurrency           = 80
cloudrun_max_instances         = 1
cloudrun_min_instances         = 1
cloudrun_allow_unauthenticated = true
cloudrun_labels = {
  environment = "dev"
  service     = "myapp"
}
# NOTE: This will be replaced by IAM module output
cloudrun_service_account_email = "" # Leave empty - will use module.iam.cloudrun_service_account_email
cloudrun_container_port        = 80
cloudrun_env_vars              = {}
cloudrun_vpc_connector         = null
cloudrun_ingress               = "ALLOW_ALL"
cloudrun_timeout               = "300s"

# ═════════════════════════════════════════════════════════════════════════════
# LOAD BALANCER CONFIGURATIONS
# ═════════════════════════════════════════════════════════════════════════════
lb_name                             = "dev-lb"
lb_negs                             = []
lb_instance_groups                  = []
lb_ssl_certificates                 = []
lb_enable_cdn                       = false
lb_cloud_armor_policy               = null
lb_create_https_listener            = false
lb_create_http_redirect             = false
lb_backend_protocol                 = "HTTP"
lb_backend_timeout                  = 30
lb_connection_draining_timeout      = 30
lb_health_check_port                = 80
lb_health_check_path                = "/"
lb_health_check_interval            = 30
lb_health_check_timeout             = 5
lb_health_check_healthy_threshold   = 2
lb_health_check_unhealthy_threshold = 2

# ═════════════════════════════════════════════════════════════════════════════
# ARTIFACT REGISTRY CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
artifact_registry_location      = "us-west1"
artifact_registry_repository_id = "dev-docker"
artifact_registry_format        = "DOCKER"
artifact_registry_description   = "Dev docker images"
artifact_registry_labels = {
  environment = "dev"
  team        = "devops"
}
artifact_registry_kms_key_name                  = "" # or the full kms key resource id if you have one
artifact_registry_enable_vulnerability_scanning = true

# IAM bindings for Artifact Registry (Cloud Build will get access via IAM module)
artifact_registry_iam_bindings = []

# ═════════════════════════════════════════════════════════════════════════════
# MEMORY STORE CONFIGURATIONS
# ═════════════════════════════════════════════════════════════════════════════
engine_type = "REDIS"
# or "REDIS_CLUSTER"
# or "MEMCACHED"

instance_id  = "dev-cache"
display_name = "Dev Cache Instance"

# Redis Classic
tier           = "STANDARD_HA"
memory_size_gb = 5
redis_version  = "REDIS_7_0"

vpc_self_link           = "projects/terraform-setup-476004/global/networks/dev-vpc"
connect_mode            = "PRIVATE_SERVICE_ACCESS"
transit_encryption_mode = "SERVER_AUTHENTICATION"

read_replicas_mode = "READ_REPLICAS_DISABLED"
replica_count      = 0

# Redis Cluster
shard_count           = 3
cluster_replica_count = 1
psc_networks = [
  "projects/terraform-setup-476004/global/networks/dev-vpc"
]

# Memcached
memcached_node_count = 2
memcached_cpu        = 2
memcached_memory_mb  = 2048

# Maintenance
maintenance_day        = "SUNDAY"
maintenance_start_hour = 3

labels = {
  environment = "dev"
  team        = "backend"
  service     = "cache"
}

# ═════════════════════════════════════════════════════════════════════════════
# APP ENGINE CONFIGURATIONS
# ═════════════════════════════════════════════════════════════════════════════
app_engine_enable_create_app = false # Set to true only for FIRST TIME creation
app_engine_use_existing_app  = true  # Set to true if App Engine app already exists

app_engine_service_name     = "default"
app_engine_version_label    = "v2"
app_engine_runtime          = "python312"
app_engine_environment_type = "standard" # or "flex"

app_engine_source_url       = "https://storage.googleapis.com/my-app-engine-source/app.zip" # for standard ZIP
app_engine_container_image  = ""                                                            # for flex
app_engine_instance_class   = "F1"
app_engine_entrypoint_shell = ""

app_engine_settings = [
  {
    name  = "ENV"
    value = "dev"
  }
]

app_engine_enable_split_traffic     = false
app_engine_migrate_traffic          = true
app_engine_split_shard_by           = "IP"
app_engine_prevent_destroy_versions = true

app_engine_tags = {
  environment = "dev"
}

settings = []

# ═════════════════════════════════════════════════════════════════════════════
# GKE CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────
# 🎮 GKE MODULE TOGGLE
# ─────────────────────────────
gke_create_node_pool = true

# ─────────────────────────────
# 🌐 BASIC CLUSTER CONFIGURATION
# ─────────────────────────────
gke_cluster_name             = "dev-gke-cluster"
gke_cluster_location         = "us-west1" # Can be region (regional cluster) or zone (zonal cluster)
gke_remove_default_node_pool = true
gke_initial_node_count       = 1
gke_min_master_version       = null  # Set to specific version like "1.28" if needed
gke_deletion_protection      = false # Set to true for production

# ─────────────────────────────
# 🔗 NETWORKING CONFIGURATION
# ─────────────────────────────
# NOTE: These will be automatically populated from VPC module when enable_vpc = true
gke_network_self_link    = ""
gke_subnetwork_self_link = ""

gke_networking_mode = "VPC_NATIVE"

# Secondary IP ranges for GKE (must be defined in your VPC subnet)
gke_cluster_secondary_range_name  = "gke-pods"     # For pod IPs
gke_services_secondary_range_name = "gke-services" # For service IPs

# ─────────────────────────────
# 🔒 PRIVATE CLUSTER CONFIGURATION
# ─────────────────────────────
gke_enable_private_cluster      = true
gke_enable_private_nodes        = true  # Nodes will have only private IPs
gke_enable_private_endpoint     = false # Set to true to make master private (requires VPN/bastion)
gke_master_ipv4_cidr_block      = "172.16.0.0/28"
gke_enable_master_global_access = false

# Authorized networks that can access the master endpoint
gke_master_authorized_networks = []

# ─────────────────────────────
# 🔐 SECURITY CONFIGURATION
# ─────────────────────────────
gke_enable_workload_identity             = true
gke_enable_binary_authorization          = false
gke_binary_authorization_evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
gke_enable_shielded_nodes                = true
gke_enable_secure_boot                   = false
gke_enable_integrity_monitoring          = true
gke_enable_database_encryption           = false
gke_database_encryption_key_name         = "" # Set if using CMEK
gke_enable_security_posture              = false
gke_security_posture_mode                = "BASIC"
gke_security_posture_vulnerability_mode  = "VULNERABILITY_DISABLED"

# ─────────────────────────────
# 🔌 ADDONS CONFIGURATION
# ─────────────────────────────
gke_enable_http_load_balancing        = true
gke_enable_horizontal_pod_autoscaling = true
gke_enable_vertical_pod_autoscaling   = false
gke_enable_network_policy             = false # Enable if you need NetworkPolicy resources
gke_network_policy_provider           = "PROVIDER_UNSPECIFIED"
gke_enable_filestore_csi_driver       = false
gke_enable_gcs_fuse_csi_driver        = false

# ─────────────────────────────
# 🔄 MAINTENANCE CONFIGURATION
# ─────────────────────────────
gke_enable_maintenance_policy = true
gke_maintenance_window_type   = "daily" # "daily" or "recurring"
gke_maintenance_start_time    = "03:00" # HH:MM format for daily window

# For recurring maintenance window (optional)
gke_maintenance_recurrence_start_time = "" # RFC3339 format
gke_maintenance_recurrence_end_time   = "" # RFC3339 format
gke_maintenance_recurrence            = "" # RRULE format

gke_release_channel = "REGULAR" # RAPID, REGULAR, STABLE, or UNSPECIFIED

# ─────────────────────────────
# 📊 MONITORING & LOGGING
# ─────────────────────────────
gke_enable_monitoring_config     = true
gke_monitoring_enable_components = ["SYSTEM_COMPONENTS"] # Can add "WORKLOADS", "APISERVER", etc.
gke_enable_managed_prometheus    = false

gke_enable_logging_config     = true
gke_logging_enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]

gke_enable_resource_usage_export         = false
gke_enable_network_egress_metering       = false
gke_enable_resource_consumption_metering = true
gke_resource_usage_export_dataset_id     = "" # Set if enabling resource usage export

# ─────────────────────────────
# 🎯 CLUSTER AUTOSCALING
# ─────────────────────────────
gke_enable_cluster_autoscaling = false
gke_autoscaling_profile        = "BALANCED" # or "OPTIMIZE_UTILIZATION"

# Resource limits for cluster-level autoscaling
gke_autoscaling_resource_limits = []

# ─────────────────────────────
# 🖥️ NODE POOL CONFIGURATION
# ─────────────────────────────
gke_node_pools = {
  # Default general-purpose node pool
  general = {
    machine_type       = "e2-medium"
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    image_type         = "COS_CONTAINERD"
    initial_node_count = 1
    min_count          = 1
    max_count          = 3
    autoscaling        = true
    preemptible        = false
    spot               = false

    labels = {
      workload = "general"
    }

    tags = ["gke-node", "general"]
  }
}

# Default node pool settings (used as fallback for pools that don't specify)
gke_node_pool_initial_node_count = 1
gke_node_pool_min_count          = 1
gke_node_pool_max_count          = 3
gke_node_pool_location_policy    = "BALANCED" # or "ANY"
gke_node_pool_machine_type       = "e2-medium"
gke_node_pool_disk_size_gb       = 100
gke_node_pool_disk_type          = "pd-standard" # or "pd-ssd"
gke_node_pool_image_type         = "COS_CONTAINERD"
gke_node_pool_preemptible        = false
gke_node_pool_spot               = false

# NOTE: This will be replaced by IAM module output
gke_node_service_account = "" # Leave empty - will use module.iam.gke_node_service_account_email

gke_node_oauth_scopes = [
  "https://www.googleapis.com/auth/cloud-platform"
]

gke_node_pool_labels = {
  environment = "dev"
  managed_by  = "terraform"
}

gke_node_pool_tags = ["gke-node"]

gke_node_pool_metadata = {
  disable-legacy-endpoints = "true"
}

gke_enable_gcfs = false # Google Container File System (image streaming)

# ─────────────────────────────
# 🔧 NODE POOL MANAGEMENT
# ─────────────────────────────
gke_auto_repair          = true
gke_auto_upgrade         = true
gke_enable_surge_upgrade = true
gke_max_surge            = 1
gke_max_unavailable      = 0

# Upgrade strategy: "SURGE" or "BLUE_GREEN"
gke_upgrade_strategy        = "SURGE"
gke_node_pool_soak_duration = "0s"
gke_batch_percentage        = null
gke_batch_node_count        = null
gke_batch_soak_duration     = "0s"

# ─────────────────────────────
# ⏱️ TIMEOUTS
# ─────────────────────────────
gke_cluster_create_timeout   = "45m"
gke_cluster_update_timeout   = "45m"
gke_cluster_delete_timeout   = "45m"
gke_node_pool_create_timeout = "30m"
gke_node_pool_update_timeout = "30m"
gke_node_pool_delete_timeout = "30m"

# ═════════════════════════════════════════════════════════════════════════════
# CDN CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
cdn_domains = ["cdn.example.com"] # managed cert applies automatically

# ORIGIN TYPE
cdn_origin_type     = "gcs"
cdn_gcs_bucket_name = "dev-static-site-terraform-setup-476004"

# CUSTOM ORIGIN (when using NEGs)
cdn_backend_group    = null # or NEG self link
cdn_health_checks    = []
cdn_backend_protocol = "HTTP"
cdn_backend_timeout  = 30

cdn_default_ttl = 3600
cdn_max_ttl     = 86400
cdn_min_ttl     = 0

cdn_forward_query_string = true

# ═════════════════════════════════════════════════════════════════════════════
# CLOUD MONITORING CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
# Logging
enable_analytics              = false
monitoring_enable_log_bucket  = true
monitoring_log_bucket_id      = "dev-log-bucket2"
monitoring_log_retention_days = 0

# Alert
monitoring_enable_alert        = true
monitoring_alert_name          = "High CPU Alert"
monitoring_metric_display_name = "GCE CPU Utilization"
monitoring_metric_filter       = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
monitoring_comparison          = "COMPARISON_GT"
monitoring_threshold_value     = 0.8
monitoring_duration            = 300
monitoring_alignment_period    = 120
monitoring_per_series_aligner  = "ALIGN_MEAN"

monitoring_notification_emails = [
  ""
]

# ═════════════════════════════════════════════════════════════════════════════
# CLOUD SPANNER CONFIGURATION
# ═════════════════════════════════════════════════════════════════════════════
# Instance configuration
spanner_instance_id     = "dev-spanner-instance"
spanner_instance_config = "regional-us-west1"

# Use ONE of the following: num_nodes OR processing_units
spanner_num_nodes        = 1
spanner_processing_units = null

# Database configuration
spanner_database_name = "dev-maindb"

# Optional DDL executed at creation
spanner_database_ddl = [
  <<EOF
  CREATE TABLE customer (
    customer_id STRING(36) NOT NULL,
    name STRING(1024),
    email STRING(1024)
  ) PRIMARY KEY (customer_id)
  EOF
]

# Labels
spanner_labels = {
  environment = "dev"
  service     = "cloudspanner"
}

# IAM Bindings
spanner_instance_iam_bindings = [
  {
    role = "roles/spanner.databaseUser"
    members = [
      "user:"
    ]
  }
]

spanner_database_iam_bindings = []