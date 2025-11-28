# ═════════════════════════════════════════════════════════════════════════════
# IAM MODULE - Comprehensive IAM Management for GCP Resources
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# 📊 Data Sources
# ─────────────────────────────────────────────────────────────────────────────
data "google_project" "project" {
  project_id = var.project_id
}

# ─────────────────────────────────────────────────────────────────────────────
# 🧑‍💼 SERVICE ACCOUNTS
# ─────────────────────────────────────────────────────────────────────────────

# Cloud Run Service Account
resource "google_service_account" "cloudrun" {
  count        = var.enable_cloudrun_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-cloudrun"
  display_name = "Service Account for Cloud Run"
  project      = var.project_id
}

# Compute Engine Service Account
resource "google_service_account" "compute" {
  count        = var.enable_compute_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-compute"
  display_name = "Service Account for Compute Engine"
  project      = var.project_id
}

# GKE Node Service Account
resource "google_service_account" "gke_node" {
  count        = var.enable_gke_node_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-gke-node"
  display_name = "Service Account for GKE Nodes"
  project      = var.project_id
}

# Cloud SQL Service Account (for proxy/client connections)
resource "google_service_account" "cloudsql_client" {
  count        = var.enable_cloudsql_client_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-cloudsql-client"
  display_name = "Service Account for Cloud SQL Client"
  project      = var.project_id
}

# App Engine Service Account
resource "google_service_account" "app_engine" {
  count        = var.enable_app_engine_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-appengine"
  display_name = "Service Account for App Engine"
  project      = var.project_id
}

# Artifact Registry Service Account
resource "google_service_account" "artifact_registry" {
  count        = var.enable_artifact_registry_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-artifact-registry"
  display_name = "Service Account for Artifact Registry"
  project      = var.project_id
}

# Memorystore Service Account
resource "google_service_account" "memorystore" {
  count        = var.enable_memorystore_sa ? 1 : 0
  account_id   = "${var.service_account_prefix}-memorystore"
  display_name = "Service Account for Memorystore"
  project      = var.project_id
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔑 CLOUD RUN IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Cloud Run → Cloud SQL Client
resource "google_project_iam_member" "cloudrun_sql_client" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_cloudsql_access ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Storage Object Viewer (for GCS access)
resource "google_project_iam_member" "cloudrun_storage_viewer" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_storage_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Secret Manager Accessor
resource "google_project_iam_member" "cloudrun_secret_accessor" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_secret_access ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Memorystore Redis User
resource "google_project_iam_member" "cloudrun_redis_user" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_memorystore_access ? 1 : 0
  project = var.project_id
  role    = "roles/redis.editor"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Artifact Registry Reader
resource "google_project_iam_member" "cloudrun_artifact_reader" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Logging Writer
resource "google_project_iam_member" "cloudrun_log_writer" {
  count   = var.enable_cloudrun_sa ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# Cloud Run → Monitoring Metric Writer
resource "google_project_iam_member" "cloudrun_monitoring_writer" {
  count   = var.enable_cloudrun_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🖥️ COMPUTE ENGINE IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Compute Engine → Cloud SQL Client
resource "google_project_iam_member" "compute_sql_client" {
  count   = var.enable_compute_sa && var.grant_compute_cloudsql_access ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.compute[0].email}"
}

# Compute Engine → Storage Object Admin
resource "google_project_iam_member" "compute_storage_admin" {
  count   = var.enable_compute_sa && var.grant_compute_storage_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.compute[0].email}"
}

# Compute Engine → Logging Writer
resource "google_project_iam_member" "compute_log_writer" {
  count   = var.enable_compute_sa ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.compute[0].email}"
}

# Compute Engine → Monitoring Metric Writer
resource "google_project_iam_member" "compute_monitoring_writer" {
  count   = var.enable_compute_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.compute[0].email}"
}

# Compute Engine → Artifact Registry Reader
resource "google_project_iam_member" "compute_artifact_reader" {
  count   = var.enable_compute_sa && var.grant_compute_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.compute[0].email}"
}

# ─────────────────────────────────────────────────────────────────────────────
# ☸️ GKE IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# GKE Node → Logging Writer
resource "google_project_iam_member" "gke_node_log_writer" {
  count   = var.enable_gke_node_sa ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Monitoring Metric Writer
resource "google_project_iam_member" "gke_node_monitoring_writer" {
  count   = var.enable_gke_node_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Monitoring Viewer
resource "google_project_iam_member" "gke_node_monitoring_viewer" {
  count   = var.enable_gke_node_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Storage Object Viewer
resource "google_project_iam_member" "gke_node_storage_viewer" {
  count   = var.enable_gke_node_sa && var.grant_gke_storage_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Artifact Registry Reader
resource "google_project_iam_member" "gke_node_artifact_reader" {
  count   = var.enable_gke_node_sa && var.grant_gke_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Cloud SQL Client (for Workload Identity)
resource "google_project_iam_member" "gke_node_sql_client" {
  count   = var.enable_gke_node_sa && var.grant_gke_cloudsql_access ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# GKE Node → Memorystore Redis User
resource "google_project_iam_member" "gke_node_redis_user" {
  count   = var.enable_gke_node_sa && var.grant_gke_memorystore_access ? 1 : 0
  project = var.project_id
  role    = "roles/redis.editor"
  member  = "serviceAccount:${google_service_account.gke_node[0].email}"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🗃️ CLOUD SQL IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Cloud SQL Client Service Account → Cloud SQL Client
resource "google_project_iam_member" "cloudsql_client_role" {
  count   = var.enable_cloudsql_client_sa ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql_client[0].email}"
}

# Cloud SQL Admin for management (only if Cloud SQL is enabled)
resource "google_project_iam_member" "cloudsql_admin" {
  for_each = var.enable_cloudsql_admin_bindings ? toset(var.cloudsql_admin_members) : []
  project  = var.project_id
  role     = "roles/cloudsql.admin"
  member   = each.value
}

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 APP ENGINE IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# App Engine → Storage Object Admin
resource "google_project_iam_member" "appengine_storage_admin" {
  count   = var.enable_app_engine_sa && var.grant_appengine_storage_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# App Engine → Cloud SQL Client
resource "google_project_iam_member" "appengine_sql_client" {
  count   = var.enable_app_engine_sa && var.grant_appengine_cloudsql_access ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# App Engine → Logging Writer
resource "google_project_iam_member" "appengine_log_writer" {
  count   = var.enable_app_engine_sa ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# App Engine → Monitoring Metric Writer
resource "google_project_iam_member" "appengine_monitoring_writer" {
  count   = var.enable_app_engine_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# App Engine → Memorystore Redis User
resource "google_project_iam_member" "appengine_redis_user" {
  count   = var.enable_app_engine_sa && var.grant_appengine_memorystore_access ? 1 : 0
  project = var.project_id
  role    = "roles/redis.editor"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# ─────────────────────────────────────────────────────────────────────────────
# 📦 ARTIFACT REGISTRY IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Artifact Registry SA → Artifact Registry Writer
resource "google_project_iam_member" "artifact_registry_writer" {
  count   = var.enable_artifact_registry_sa ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.artifact_registry[0].email}"
}

# Cloud Build → Artifact Registry Writer
resource "google_project_iam_member" "cloudbuild_artifact_writer" {
  count   = var.grant_cloudbuild_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Cloud Build → Storage Admin (for build artifacts)
resource "google_project_iam_member" "cloudbuild_storage_admin" {
  count   = var.grant_cloudbuild_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Cloud Build → Logging Writer
resource "google_project_iam_member" "cloudbuild_log_writer" {
  count   = var.grant_cloudbuild_artifact_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🗄️ STORAGE IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Storage Admins (only if storage is enabled)
resource "google_project_iam_member" "storage_admin" {
  for_each = var.enable_storage_admin_bindings ? toset(var.storage_admin_members) : []
  project  = var.project_id
  role     = "roles/storage.admin"
  member   = each.value
}

# Storage Object Viewers (only if storage is enabled)
resource "google_project_iam_member" "storage_viewer" {
  for_each = var.enable_storage_viewer_bindings ? toset(var.storage_viewer_members) : []
  project  = var.project_id
  role     = "roles/storage.objectViewer"
  member   = each.value
}

# CDN Service Account → Storage Object Viewer (for CDN backend)
resource "google_project_iam_member" "cdn_storage_viewer" {
  count   = var.grant_cdn_storage_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:service-${data.google_project.project.number}@cloud-cdn-fill.iam.gserviceaccount.com"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 KMS IAM BINDINGS (for Cloud SQL encryption)
# ─────────────────────────────────────────────────────────────────────────────

# Cloud SQL Service Agent → KMS Crypto Key Encrypter/Decrypter
resource "google_kms_crypto_key_iam_member" "cloudsql_kms" {
  count = var.enable_cloudsql_kms_binding ? 1 : 0

  crypto_key_id = try(var.kms_crypto_key_id, null)
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}


# GKE Service Agent → KMS Crypto Key Encrypter/Decrypter (for GKE secrets encryption)
resource "google_kms_crypto_key_iam_member" "gke_kms" {
  count         = var.enable_gke_kms_binding && var.gke_kms_crypto_key_id != "" ? 1 : 0
  crypto_key_id = var.gke_kms_crypto_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

# ─────────────────────────────────────────────────────────────────────────────
# 📊 MONITORING & LOGGING IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Monitoring Admins (only if monitoring is enabled)
resource "google_project_iam_member" "monitoring_admin" {
  for_each = var.enable_monitoring_admin_bindings ? toset(var.monitoring_admin_members) : []
  project  = var.project_id
  role     = "roles/monitoring.admin"
  member   = each.value
}

# Logging Admins (only if logging is enabled)
resource "google_project_iam_member" "logging_admin" {
  for_each = var.enable_logging_admin_bindings ? toset(var.logging_admin_members) : []
  project  = var.project_id
  role     = "roles/logging.admin"
  member   = each.value
}

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 LOAD BALANCER & CDN IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Load Balancer Admins (only if load balancer is enabled)
resource "google_project_iam_member" "lb_admin" {
  for_each = var.enable_lb_admin_bindings ? toset(var.lb_admin_members) : []
  project  = var.project_id
  role     = "roles/compute.loadBalancerAdmin"
  member   = each.value
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 MEMORYSTORE IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Memorystore SA → Redis Editor
resource "google_project_iam_member" "memorystore_redis_editor" {
  count   = var.enable_memorystore_sa ? 1 : 0
  project = var.project_id
  role    = "roles/redis.editor"
  member  = "serviceAccount:${google_service_account.memorystore[0].email}"
}

# Memorystore Admins (only if memorystore is enabled)
resource "google_project_iam_member" "memorystore_admin" {
  for_each = var.enable_memorystore_admin_bindings ? toset(var.memorystore_admin_members) : []
  project  = var.project_id
  role     = "roles/redis.admin"
  member   = each.value
}

# ─────────────────────────────────────────────────────────────────────────────
# 🎯 GKE WORKLOAD IDENTITY BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Kubernetes Service Account → GCP Service Account binding for Workload Identity
resource "google_service_account_iam_member" "gke_workload_identity" {
  for_each = var.gke_workload_identity_bindings

  service_account_id = each.value.gcp_service_account_email
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${each.value.k8s_namespace}/${each.value.k8s_service_account}]"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 CUSTOM IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────

# Custom project-level IAM bindings
resource "google_project_iam_member" "custom" {
  for_each = var.custom_iam_bindings

  project = var.project_id
  role    = each.value.role
  member  = each.value.member

  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      title       = condition.value.title
      description = condition.value.description
      expression  = condition.value.expression
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 🚦 SERVICE ACCOUNT PERMISSIONS FOR VPC ACCESS
# ─────────────────────────────────────────────────────────────────────────────

# VPC Access User for Cloud Run
resource "google_project_iam_member" "cloudrun_vpc_access" {
  count   = var.enable_cloudrun_sa && var.grant_cloudrun_vpc_access ? 1 : 0
  project = var.project_id
  role    = "roles/vpcaccess.user"
  member  = "serviceAccount:${google_service_account.cloudrun[0].email}"
}

# VPC Access User for App Engine
resource "google_project_iam_member" "appengine_vpc_access" {
  count   = var.enable_app_engine_sa && var.grant_appengine_vpc_access ? 1 : 0
  project = var.project_id
  role    = "roles/vpcaccess.user"
  member  = "serviceAccount:${google_service_account.app_engine[0].email}"
}

# ─────────────────────────────────────────────────────────────────────────────
# 📝 PROJECT-LEVEL API ENABLEMENT ROLES
# ─────────────────────────────────────────────────────────────────────────────

# Service Usage Consumer (for API enablement)
resource "google_project_iam_member" "service_usage_consumer" {
  for_each = toset(var.service_usage_consumer_members)
  project  = var.project_id
  role     = "roles/serviceusage.serviceUsageConsumer"
  member   = each.value
}