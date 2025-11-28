variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "force_destroy" {
  description = "Delete all objects in the bucket when destroying"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "enable_static_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

variable "index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for static website"
  type        = string
  default     = "404.html"
}

variable "enable_public_access" {
  description = "Enable public access for the bucket"
  type        = bool
  default     = false
}

variable "public_access_members" {
  description = "IAM members for public access"
  type        = list(string)
  default     = ["allUsers"]
}

variable "labels" {
  description = "Labels for the bucket"
  type        = map(string)
  default     = {}
}
