variable "create_repo" {
  description = "Create the Artifact Registry repository"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "GCP project id where the repository will be created"
  type        = string
}

variable "location" {
  description = "Region for the repository (eg. us-west1, us-central1). For Docker repo this is regional."
  type        = string
  default     = "us-central1"
}

variable "repository_id" {
  description = "Short repository id (no slashes). Example: my-docker-repo"
  type        = string
}

variable "format" {
  description = "Repository format (DOCKER, MAVEN, NPM, PYTHON, APT, YUM, etc.)"
  type        = string
  default     = "DOCKER"
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Labels to apply to the repository"
  type        = map(string)
  default     = {}
}

variable "kms_key_name" {
  description = "Optional full KMS crypto key resource name to use for repository encryption. Leave empty to use Google-managed encryption. Example: projects/PROJECT/locations/global/keyRings/KEYRING/cryptoKeys/KEY"
  type        = string
  default     = ""
}

variable "enable_vulnerability_scanning" {
  description = "Enable Container Analysis API for image scanning (enables the API only). Actual scanning happens via Container Analysis features."
  type        = bool
  default     = true
}

variable "iam_bindings" {
  description = <<-EOT
    Optional list of maps to bind IAM roles at repository level.
    Each item: { role = "roles/artifactregistry.reader", members = ["serviceAccount:..."] }
  EOT
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}
