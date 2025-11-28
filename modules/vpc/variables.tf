variable "enable_vpc" {
  description = "Whether to create the VPC and related resources."
  type        = bool
  default     = true
}

variable "region" {
  description = "Region to create the VPC in."
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets."
  type        = list(string)
}

variable "project_id" {
  type = string
}

# GKE
variable "enable_gke_secondary_ranges" {
  description = "Enable secondary IP ranges for GKE"
  type        = bool
  default     = false
}

variable "gke_pods_range_name" {
  description = "Name of secondary range for GKE pods"
  type        = string
  default     = "gke-pods"
}

variable "gke_pods_cidr_range" {
  description = "CIDR range for GKE pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "gke_services_range_name" {
  description = "Name of secondary range for GKE services"
  type        = string
  default     = "gke-services"
}

variable "gke_services_cidr_range" {
  description = "CIDR range for GKE services"
  type        = string
  default     = "10.2.0.0/16"
}