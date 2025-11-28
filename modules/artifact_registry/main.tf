data "google_project" "project" {
  project_id = var.project_id
}

terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.10" # or any recent version
    }
  }
}


####################################################################
# Artifact Registry repository + supporting APIs
####################################################################

# Ensure Artifact Registry API + Container Analysis (for scanning) are enabled
resource "google_project_service" "artifact_registry" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container_analysis" {
  count              = var.enable_vulnerability_scanning ? 1 : 0
  project            = var.project_id
  service            = "containeranalysis.googleapis.com"
  disable_on_destroy = false
}

# Create the repository
resource "google_artifact_registry_repository" "repo" {
  count         = var.create_repo ? 1 : 0
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = var.format
  labels        = var.labels

  # If a KMS crypto key full resource id is provided, attach it.
  kms_key_name = var.kms_key_name != "" ? var.kms_key_name : null

  # Optional settings available depending on format / API version:
  # Note: terraform provider may ignore unknown fields for some formats.
  timeouts {}
}

# Optionally allow specified IAM bindings (list of maps: role, member)
locals {
  cloudbuild_sa = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_artifact_registry_repository_iam_binding" "bindings" {
  count      = length(var.iam_bindings)
  repository = google_artifact_registry_repository.repo[0].name
  location   = var.location
  project    = var.project_id
  role       = var.iam_bindings[count.index].role

  members = coalesce(
    var.iam_bindings[count.index].members,
    [local.cloudbuild_sa]
  )

  depends_on = [
    time_sleep.wait_for_artifact_registry,
    google_project_service.artifact_registry,
    google_project_service.container_analysis,
  ]
}

resource "time_sleep" "wait_for_artifact_registry" {
  depends_on      = [google_artifact_registry_repository.repo]
  create_duration = "20s" # wait 20 seconds before continuing
}
