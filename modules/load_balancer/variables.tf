variable "create_lb" {
  description = "Enable or disable Load Balancer"
  type        = bool
  default     = true
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "ssl_certificates" {
  description = "List of certificate self_links"
  type        = list(string)
  default     = []
}

variable "create_https_listener" {
  type    = bool
  default = true
}

variable "create_http_redirect" {
  type    = bool
  default = true
}

variable "enable_cdn" {
  type    = bool
  default = false
}

variable "enable_access_logs" {
  type    = bool
  default = false
}

variable "backend_protocol" {
  type    = string
  default = "HTTP"
}

variable "backend_timeout" {
  type    = number
  default = 30
}

variable "connection_draining_timeout" {
  type    = number
  default = 30
}

variable "cloud_armor_policy" {
  type    = string
  default = null
}

# Backends
variable "negs" {
  description = "List of NEG self_links"
  type        = list(string)
  default     = []
}

variable "instance_groups" {
  description = "List of Instance Group self_links"
  type        = list(string)
  default     = []
}

# Health check configuration
variable "health_check_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 2
}

variable "lb_instance_groups" {
  type = list(string)
  default = []
  description = "Instance group self links for backend service"
}



