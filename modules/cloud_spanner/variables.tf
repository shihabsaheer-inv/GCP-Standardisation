# Required
variable "project_id" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "instance_config" {
  type = string
}

variable "database_name" {
  type = string
}

# Optional
variable "display_name" {
  type    = string
  default = null
}

variable "num_nodes" {
  type    = number
  default = null
}

variable "processing_units" {
  type    = number
  default = null
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "database_ddl" {
  type    = list(string)
  default = []
}

# IAM
variable "instance_iam_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

variable "database_iam_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

variable "deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection on the Spanner database"
  default     = false
}

variable "enable_drop_protection" {
  type        = bool
  description = "Whether to enable drop protection for the Spanner database"
  default     = false
}
