variable "enable_firewall" {
  description = "Enable firewall rules"
  type        = bool
  default     = true
}

variable "network_self_link" {
  description = "Self link of the VPC network"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "ssh_source_ranges" {
  description = "CIDR ranges allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "internal_source_ranges" {
  description = "CIDR ranges for internal traffic"
  type        = list(string)
}

