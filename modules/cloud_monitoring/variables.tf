variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "project_id" {
  type = string
}

variable "location" {
  type    = string
  default = "global"
}

############################
# Log Bucket
############################
variable "enable_log_bucket" {
  type    = bool
  default = false
}

variable "log_bucket_id" {
  type    = string
  default = "custom-log-bucket"
}

variable "log_retention_days" {
  type    = number
  default = 0
}

############################
# Alerting
############################
variable "enable_alert" {
  type    = bool
  default = false
}

variable "alert_name" {
  type    = string
  default = "High CPU Alert"
}

variable "metric_display_name" {
  type    = string
  default = "CPU Utilization"
}

variable "metric_filter" {
  type = string
  # Example:
  # "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
}

variable "comparison" {
  type    = string
  default = "COMPARISON_GT"
}

variable "threshold_value" {
  type    = number
  default = 0.8
}

variable "duration" {
  type        = number
  default     = 300 # seconds
  description = "How long metric must violate threshold"
}

variable "alignment_period" {
  type    = number
  default = 120
}

variable "per_series_aligner" {
  type    = string
  default = "ALIGN_MEAN"
}

############################
# Notification Channels
############################
variable "notification_emails" {
  type    = list(string)
  default = []
}

# -------------------------------------------------------
# Restricted fields (list of strings)
# -------------------------------------------------------
variable "restricted_fields" {
  description = "List of field names to restrict in the metric descriptor"
  type        = list(string)
  default     = []
}

variable "enable_analytics" {
  description = "Enable Log Analytics for the bucket"
  type        = bool
  default     = false
}
