variable "name" {
  description = "Name prefix"
  type        = string
}

variable "enable_cdn" {
  description = "Enable Cloud CDN"
  type        = bool
  default     = true
}

variable "origin_type" {
  description = "Origin type: gcs or custom"
  type        = string
  default     = "gcs"
}

variable "gcs_bucket_name" {
  type    = string
  default = null
}

variable "backend_group" {
  type    = string
  default = null
}

variable "backend_protocol" {
  type    = string
  default = "HTTP"
}

variable "backend_timeout" {
  type    = number
  default = 30
}

variable "health_checks" {
  type    = list(string)
  default = []
}

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
  type    = bool
  default = false
}

variable "host_rules" {
  type = list(object({
    hosts        = list(string)
    path_matcher = string
  }))
  default = []
}

variable "path_matchers" {
  type = list(object({
    name = string
  }))
  default = []
}

variable "enable_https" {
  type    = bool
  default = false
}

variable "ssl_certificates" {
  type    = list(string)
  default = []
}

variable "global_ip" {
  type    = string
  default = null
}
