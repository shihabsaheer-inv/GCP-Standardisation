##############################################################

variable "create" {
  description = "Toggle to create Cloud Run service"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for Cloud Run service"
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Cloud Run service name"
  type        = string
}

variable "image" {
  description = "Container image URL (e.g. gcr.io/... or <region>-docker.pkg.dev/...)"
  type        = string
}

variable "port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "memory" {
  description = "Memory limit (e.g. 256Mi, 512Mi, 1Gi)"
  type        = string
  default     = "512Mi"
}

variable "cpu" {
  description = "CPU allocation (e.g. 1, 2)"
  type        = string
  default     = "1"
}

variable "concurrency" {
  description = "Request concurrency per container (0 for automatic)"
  type        = number
  default     = 80
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 0
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "env_vars" {
  description = "Map of environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "service_account_email" {
  description = "Service account email used by the Cloud Run service"
  type        = string
  default     = null
}

variable "vpc_connector" {
  description = "VPC connector name (optional)"
  type        = string
  default     = null
}

variable "ingress" {
  description = "Ingress policy: ALLOW_ALL, INTERNAL_ONLY, or INTERNAL_AND_GCLB"
  type        = string
  default     = "ALLOW_ALL"
}

variable "allow_unauthenticated" {
  description = "If true, allow unauthenticated invocations (public)"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to the Cloud Run service"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Request timeout in seconds (e.g. 300s)"
  type        = string
  default     = "300s"
}

variable "enable_cloudsql_connection" {
  description = "Whether to connect Cloud Run to Cloud SQL"
  type        = bool
  default     = false
}

variable "cloudsql_connection_name" {
  description = "Cloud SQL instance connection name (project:region:instance)"
  type        = string
  default     = null
}
