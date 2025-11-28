# modules/app_engine/variables.tf

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "location_id" {
  description = "App Engine region for creation (e.g. us-central1). Only used when enable_create_app = true"
  type        = string
  default     = "us-central1"
}

variable "enable_create_app" {
  description = "If true, Terraform will CREATE the App Engine application (only use for the very first-time creation)."
  type        = bool
  default     = false
}

variable "enable_use_existing_app" {
  description = "If true, Terraform will read an existing App Engine application via data source. Use this if app exists already."
  type        = bool
  default     = true
}

variable "service_name" {
  description = "App Engine service name (first deployment must use 'default')"
  type        = string
  default     = "default"
}

variable "version_label" {
  description = "Version label for the deployment (e.g. v1, v2)"
  type        = string
  default     = "v1"
}

variable "runtime" {
  description = "App Engine runtime (python312, nodejs20, etc.)"
  type        = string
  default     = "python312"
}

variable "environment_type" {
  description = "App Engine environment type: standard or flex"
  type        = string
  default     = "standard"
}

variable "source_url" {
  description = "GCS zip URL for Standard environment deployment. Example: https://storage.googleapis.com/bucket/app.zip"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Container image for Flexible environment (gcr.io/PROJECT/image:tag)"
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "Instance class for Standard environment (F1, F2, F4, etc.)"
  type        = string
  default     = "F1"
}

variable "entrypoint_shell" {
  description = "Entrypoint shell for Standard environment (keeps provider happy). Use empty string for default."
  type        = string
  default     = ""
}

variable "settings" {
  description = "Key-value settings similar to option_settings. Will be mapped to env_variables"
  type = list(object({
    name      = string
    value     = string
  }))
  default = []
}

# Prevent Terraform from attempting to delete versions (recommended true)
variable "prevent_destroy_versions" {
  description = "If true, prevents Terraform from destroying App Engine versions (safest)."
  type        = bool
  default     = true
}

# Traffic split controls
variable "enable_split_traffic" {
  description = "If true, module will create a service traffic split resource (set to true to route traffic to new version)."
  type        = bool
  default     = false
}

variable "migrate_traffic" {
  description = "Whether to migrate traffic when creating the split (true/false)."
  type        = bool
  default     = true
}

variable "split_shard_by" {
  description = "Shard method for split: IP or COOKIE"
  type        = string
  default     = "IP"
}

# Flexible defaults
variable "flex_liveness_path" {
  type    = string
  default = "/"
}

variable "flex_readiness_path" {
  type    = string
  default = "/"
}

variable "flex_cpu_target_utilization" {
  type    = number
  default = 0.6
}

variable "flex_min_total_instances" {
  type    = number
  default = 1
}

variable "flex_max_total_instances" {
  type    = number
  default = 1
}
