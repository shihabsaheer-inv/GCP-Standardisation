# ═════════════════════════════════════════════════════════════════════════════
# IAM MODULE VARIABLES
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 COMMON VARIABLES
# ─────────────────────────────────────────────────────────────────────────────
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "service_account_prefix" {
  description = "Prefix for service account names"
  type        = string
  default     = "sa"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🎛️ SERVICE ACCOUNT TOGGLES
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_cloudrun_sa" {
  description = "Create service account for Cloud Run"
  type        = bool
  default     = false
}

variable "enable_compute_sa" {
  description = "Create service account for Compute Engine"
  type        = bool
  default     = false
}

variable "enable_gke_node_sa" {
  description = "Create service account for GKE nodes"
  type        = bool
  default     = false
}

variable "enable_cloudsql_client_sa" {
  description = "Create service account for Cloud SQL client connections"
  type        = bool
  default     = false
}

variable "enable_app_engine_sa" {
  description = "Create service account for App Engine"
  type        = bool
  default     = false
}

variable "enable_artifact_registry_sa" {
  description = "Create service account for Artifact Registry"
  type        = bool
  default     = false
}

variable "enable_memorystore_sa" {
  description = "Create service account for Memorystore"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# ☁️ CLOUD RUN IAM PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────
variable "grant_cloudrun_cloudsql_access" {
  description = "Grant Cloud Run access to Cloud SQL"
  type        = bool
  default     = false
}

variable "grant_cloudrun_storage_access" {
  description = "Grant Cloud Run access to Cloud Storage"
  type        = bool
  default     = false
}

variable "grant_cloudrun_secret_access" {
  description = "Grant Cloud Run access to Secret Manager"
  type        = bool
  default     = false
}

variable "grant_cloudrun_memorystore_access" {
  description = "Grant Cloud Run access to Memorystore"
  type        = bool
  default     = false
}

variable "grant_cloudrun_artifact_registry_access" {
  description = "Grant Cloud Run access to Artifact Registry"
  type        = bool
  default     = false
}

variable "grant_cloudrun_vpc_access" {
  description = "Grant Cloud Run VPC access permissions"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# 🖥️ COMPUTE ENGINE IAM PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────
variable "grant_compute_cloudsql_access" {
  description = "Grant Compute Engine access to Cloud SQL"
  type        = bool
  default     = false
}

variable "grant_compute_storage_access" {
  description = "Grant Compute Engine access to Cloud Storage"
  type        = bool
  default     = false
}

variable "grant_compute_artifact_registry_access" {
  description = "Grant Compute Engine access to Artifact Registry"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# ☸️ GKE IAM PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────
variable "grant_gke_storage_access" {
  description = "Grant GKE nodes access to Cloud Storage"
  type        = bool
  default     = false
}

variable "grant_gke_artifact_registry_access" {
  description = "Grant GKE nodes access to Artifact Registry"
  type        = bool
  default     = true
}

variable "grant_gke_cloudsql_access" {
  description = "Grant GKE nodes access to Cloud SQL"
  type        = bool
  default     = false
}

variable "grant_gke_memorystore_access" {
  description = "Grant GKE nodes access to Memorystore"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 APP ENGINE IAM PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────
variable "grant_appengine_storage_access" {
  description = "Grant App Engine access to Cloud Storage"
  type        = bool
  default     = false
}

variable "grant_appengine_cloudsql_access" {
  description = "Grant App Engine access to Cloud SQL"
  type        = bool
  default     = false
}

variable "grant_appengine_memorystore_access" {
  description = "Grant App Engine access to Memorystore"
  type        = bool
  default     = false
}

variable "grant_appengine_vpc_access" {
  description = "Grant App Engine VPC access permissions"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# 📦 ARTIFACT REGISTRY IAM PERMISSIONS
# ─────────────────────────────────────────────────────────────────────────────
variable "grant_cloudbuild_artifact_registry_access" {
  description = "Grant Cloud Build access to Artifact Registry"
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────────────────────────────────────
# 🗄️ STORAGE IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_storage_admin_bindings" {
  description = "Enable storage admin IAM bindings (only if storage is enabled)"
  type        = bool
  default     = false
}

variable "storage_admin_members" {
  description = "List of members to grant Storage Admin role"
  type        = list(string)
  default     = []
}

variable "storage_viewer_members" {
  description = "List of members to grant Storage Object Viewer role"
  type        = list(string)
  default     = []
}

variable "grant_cdn_storage_access" {
  description = "Grant CDN service account access to Cloud Storage"
  type        = bool
  default     = false
}

variable "enable_storage_viewer_bindings" {
  description = "Enable storage viewer IAM bindings"
  type        = bool
  default     = false
}

variable "cdn_backend_bucket" {
  type = string
  default = null
}

variable "cdn_url_map" {
  type = string
  default = null
}

variable "cdn_dependency" {
  type    = string
  default = null
}

variable "cdn_origin_type" {
  type        = string
  default     = "gcs"
  description = "CDN origin type (gcs or custom)"
}

# ─────────────────────────────────────────────────────────────────────────────
# 🗃️ CLOUD SQL IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_cloudsql_admin_bindings" {
  description = "Enable Cloud SQL admin IAM bindings (only if Cloud SQL is enabled)"
  type        = bool
  default     = false
}

variable "cloudsql_admin_members" {
  description = "List of members to grant Cloud SQL Admin role"
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 KMS IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_cloudsql_kms_binding" {
  description = "Enable KMS binding for Cloud SQL encryption"
  type        = bool
  default     = false
}

variable "kms_crypto_key_id" {
  description = "Full KMS crypto key ID for Cloud SQL encryption"
  type        = string
  default     = ""
}

variable "enable_gke_kms_binding" {
  description = "Enable KMS binding for GKE secrets encryption"
  type        = bool
  default     = false
}

variable "gke_kms_crypto_key_id" {
  description = "Full KMS crypto key ID for GKE secrets encryption"
  type        = string
  default     = ""
}

# ─────────────────────────────────────────────────────────────────────────────
# 📊 MONITORING & LOGGING IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_monitoring_admin_bindings" {
  description = "Enable monitoring admin IAM bindings (only if monitoring is enabled)"
  type        = bool
  default     = false
}

variable "monitoring_admin_members" {
  description = "List of members to grant Monitoring Admin role"
  type        = list(string)
  default     = []
}

variable "enable_logging_admin_bindings" {
  description = "Enable logging admin IAM bindings (only if logging is enabled)"
  type        = bool
  default     = false
}

variable "logging_admin_members" {
  description = "List of members to grant Logging Admin role"
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────────────────────────────────────
# 🌐 LOAD BALANCER IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_lb_admin_bindings" {
  description = "Enable load balancer admin IAM bindings (only if load balancer is enabled)"
  type        = bool
  default     = false
}

variable "lb_admin_members" {
  description = "List of members to grant Load Balancer Admin role"
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔄 MEMORYSTORE IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "enable_memorystore_admin_bindings" {
  description = "Enable Memorystore admin IAM bindings (only if Memorystore is enabled)"
  type        = bool
  default     = false
}

variable "memorystore_admin_members" {
  description = "List of members to grant Memorystore Admin role"
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────────────────────────────────────
# ☸️ GKE WORKLOAD IDENTITY BINDINGS
# ─────────────────────────────────────────────────────────────────────────────
variable "gke_workload_identity_bindings" {
  description = "Map of Workload Identity bindings (K8s SA to GCP SA)"
  type = map(object({
    gcp_service_account_email = string
    k8s_namespace             = string
    k8s_service_account       = string
  }))
  default = {}
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔧 CUSTOM IAM BINDINGS
# ─────────────────────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────────────────────
# 📝 API ENABLEMENT IAM MEMBERS
# ─────────────────────────────────────────────────────────────────────────────
variable "service_usage_consumer_members" {
  description = "List of members to grant Service Usage Consumer role"
  type        = list(string)
  default     = []
}