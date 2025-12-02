variable "name" {
  description = "Name prefix for all CDN resources"
  type        = string
}

variable "enable_cdn" {
  description = "Enable or disable Cloud CDN + Load Balancer"
  type        = bool
  default     = true
}

variable "origin_type" {
  description = "Origin type: gcs or custom"
  type        = string
  default     = "gcs"
}

###################################
# GCS ORIGIN
###################################
variable "gcs_bucket_name" {
  description = "GCS bucket name used as Cloud CDN origin"
  type        = string
  default     = null
}

###################################
# CUSTOM ORIGIN (NEGs / MIGs)
###################################
variable "backend_group" {
  description = "NEG or Instance Group self-link to use as custom origin"
  type        = string
  default     = null
}

variable "backend_protocol" {
  description = "Backend protocol for custom origins"
  type        = string
  default     = "HTTP"
}

variable "backend_timeout" {
  description = "Origin timeout"
  type        = number
  default     = 30
}

variable "health_checks" {
  description = "List of health check self-links (only for custom origins)"
  type        = list(string)
  default     = []
}

###################################
# CDN CACHE SETTINGS
###################################
variable "default_ttl" {
  type    = number
  default = 3600
}

variable "max_ttl" {
  type    = number
  default = 86400
}

variable "min_ttl" {
  type    = number
  default = 0
}

variable "forward_query_string" {
  description = "Forward query string to origin"
  type        = bool
  default     = false
}

###################################
# URL MAP ROUTING
###################################
variable "host_rules" {
  description = "List of host rules"
  type = list(object({
    hosts        = list(string)
    path_matcher = string
  }))
  default = []
}

variable "path_matchers" {
  description = "List of path matchers and optional path rules"
  type = list(object({
    name        = string
    # OPTIONAL: allow per-path routing
    path_rules = optional(list(object({
      paths   = list(string)
      service = string
    })), [])
  }))
  default = []
}

###################################
# HTTPS CONFIGURATION
###################################
variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "List of SSL certificate self-links"
  type        = list(string)
  default     = []
}

###################################
# GLOBAL IP
###################################
variable "global_ip" {
  description = "Global IP for LB (static)"
  type        = string
  default     = null
}
