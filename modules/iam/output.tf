# ═════════════════════════════════════════════════════════════════════════════
# IAM MODULE OUTPUTS
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# 📧 SERVICE ACCOUNT EMAILS
# ─────────────────────────────────────────────────────────────────────────────
output "cloudrun_service_account_email" {
  description = "Email of the Cloud Run service account"
  value       = var.enable_cloudrun_sa ? google_service_account.cloudrun[0].email : null
}

output "compute_service_account_email" {
  description = "Email of the Compute Engine service account"
  value       = var.enable_compute_sa ? google_service_account.compute[0].email : null
}

output "gke_node_service_account_email" {
  description = "Email of the GKE node service account"
  value       = var.enable_gke_node_sa ? google_service_account.gke_node[0].email : null
}

output "cloudsql_client_service_account_email" {
  description = "Email of the Cloud SQL client service account"
  value       = var.enable_cloudsql_client_sa ? google_service_account.cloudsql_client[0].email : null
}

output "app_engine_service_account_email" {
  description = "Email of the App Engine service account"
  value       = var.enable_app_engine_sa ? google_service_account.app_engine[0].email : null
}

output "artifact_registry_service_account_email" {
  description = "Email of the Artifact Registry service account"
  value       = var.enable_artifact_registry_sa ? google_service_account.artifact_registry[0].email : null
}

output "memorystore_service_account_email" {
  description = "Email of the Memorystore service account"
  value       = var.enable_memorystore_sa ? google_service_account.memorystore[0].email : null
}

# ─────────────────────────────────────────────────────────────────────────────
# 🆔 SERVICE ACCOUNT IDs
# ─────────────────────────────────────────────────────────────────────────────
output "cloudrun_service_account_id" {
  description = "ID of the Cloud Run service account"
  value       = var.enable_cloudrun_sa ? google_service_account.cloudrun[0].id : null
}

output "compute_service_account_id" {
  description = "ID of the Compute Engine service account"
  value       = var.enable_compute_sa ? google_service_account.compute[0].id : null
}

output "gke_node_service_account_id" {
  description = "ID of the GKE node service account"
  value       = var.enable_gke_node_sa ? google_service_account.gke_node[0].id : null
}

output "cloudsql_client_service_account_id" {
  description = "ID of the Cloud SQL client service account"
  value       = var.enable_cloudsql_client_sa ? google_service_account.cloudsql_client[0].id : null
}

output "app_engine_service_account_id" {
  description = "ID of the App Engine service account"
  value       = var.enable_app_engine_sa ? google_service_account.app_engine[0].id : null
}

output "artifact_registry_service_account_id" {
  description = "ID of the Artifact Registry service account"
  value       = var.enable_artifact_registry_sa ? google_service_account.artifact_registry[0].id : null
}

output "memorystore_service_account_id" {
  description = "ID of the Memorystore service account"
  value       = var.enable_memorystore_sa ? google_service_account.memorystore[0].id : null
}

# ─────────────────────────────────────────────────────────────────────────────
# 📋 ALL SERVICE ACCOUNTS MAP
# ─────────────────────────────────────────────────────────────────────────────
output "service_accounts" {
  description = "Map of all created service accounts"
  value = {
    cloudrun           = var.enable_cloudrun_sa ? google_service_account.cloudrun[0].email : null
    compute            = var.enable_compute_sa ? google_service_account.compute[0].email : null
    gke_node           = var.enable_gke_node_sa ? google_service_account.gke_node[0].email : null
    cloudsql_client    = var.enable_cloudsql_client_sa ? google_service_account.cloudsql_client[0].email : null
    app_engine         = var.enable_app_engine_sa ? google_service_account.app_engine[0].email : null
    artifact_registry  = var.enable_artifact_registry_sa ? google_service_account.artifact_registry[0].email : null
    memorystore        = var.enable_memorystore_sa ? google_service_account.memorystore[0].email : null
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔑 IAM BINDINGS SUMMARY
# ─────────────────────────────────────────────────────────────────────────────
output "iam_bindings_summary" {
  description = "Summary of IAM bindings created"
  value = {
    cloudrun_permissions = {
      cloudsql_access         = var.grant_cloudrun_cloudsql_access
      storage_access          = var.grant_cloudrun_storage_access
      secret_access           = var.grant_cloudrun_secret_access
      memorystore_access      = var.grant_cloudrun_memorystore_access
      artifact_registry_access = var.grant_cloudrun_artifact_registry_access
      vpc_access              = var.grant_cloudrun_vpc_access
    }
    compute_permissions = {
      cloudsql_access         = var.grant_compute_cloudsql_access
      storage_access          = var.grant_compute_storage_access
      artifact_registry_access = var.grant_compute_artifact_registry_access
    }
    gke_permissions = {
      storage_access           = var.grant_gke_storage_access
      artifact_registry_access = var.grant_gke_artifact_registry_access
      cloudsql_access          = var.grant_gke_cloudsql_access
      memorystore_access       = var.grant_gke_memorystore_access
    }
    appengine_permissions = {
      storage_access     = var.grant_appengine_storage_access
      cloudsql_access    = var.grant_appengine_cloudsql_access
      memorystore_access = var.grant_appengine_memorystore_access
      vpc_access         = var.grant_appengine_vpc_access
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 🔐 KMS BINDINGS
# ─────────────────────────────────────────────────────────────────────────────
output "kms_bindings" {
  description = "KMS encryption bindings"
  value = {
    cloudsql_kms_enabled = var.enable_cloudsql_kms_binding
    gke_kms_enabled      = var.enable_gke_kms_binding
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 📊 PROJECT INFORMATION
# ─────────────────────────────────────────────────────────────────────────────
output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "project_number" {
  description = "GCP Project Number"
  value       = data.google_project.project.number
}

# ─────────────────────────────────────────────────────────────────────────────
# 🤖 SYSTEM SERVICE ACCOUNTS
# ─────────────────────────────────────────────────────────────────────────────
output "system_service_accounts" {
  description = "System-managed service accounts"
  value = {
    cloudbuild_sa        = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
    cloudsql_sa          = "service-${data.google_project.project.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
    gke_sa               = "service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
    cdn_sa               = "service-${data.google_project.project.number}@cloud-cdn-fill.iam.gserviceaccount.com"
    compute_default_sa   = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# 📝 WORKLOAD IDENTITY BINDINGS
# ─────────────────────────────────────────────────────────────────────────────
output "workload_identity_bindings" {
  description = "GKE Workload Identity bindings created"
  value = {
    for k, v in var.gke_workload_identity_bindings : k => {
      gcp_sa  = v.gcp_service_account_email
      k8s_sa  = "${v.k8s_namespace}/${v.k8s_service_account}"
    }
  }
}