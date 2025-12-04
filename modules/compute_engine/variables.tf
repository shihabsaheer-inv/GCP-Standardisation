variable "enable_compute_engine" {
  description = "Toggle to enable or disable the creation of Compute Engine instances"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Region to create the resources in"
  type        = string
}

variable "zone" {
  description = "Zone to create the resources in"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_name_prefix" {
  description = "Prefix for the instance names"
  type        = string
  default     = "gcp-instance"
}

variable "instance_type" {
  description = "Machine type for the instances"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of the boot disk (e.g., pd-standard, pd-ssd)"
  type        = string
  default     = "pd-ssd"
}

variable "image" {
  description = "Image to use for the instances"
  type        = string
  default     = "projects/debian-cloud/global/images/debian-10-buster-v20201014"
}

variable "service_account_email" {
  description = "Service account email for the instances"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the instances"
  type        = bool
  default     = false
}

variable "network_name" {
  description = "The name of the network to attach the instance to"
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "The name of the subnetwork to attach the instance to"
  type        = string
  default     = "default"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address to the instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "List of network tags for the VM"
  type        = list(string)
  default     = []
}

variable "use_sequential_naming" {
  description = "Use sequential naming for instances"
  type        = bool
  default     = true
}

variable "name_padding" {
  type        = number # Changed from string
  description = "Number of digits to pad the instance name"
  default     = 2
}


variable "instance_tags" {
  description = "Network tags to assign to the instance"
  type        = list(string)
  default     = []
}

variable "instance_roles" {
  description = "Map index to role: frontend, backend, db"
  type        = map(string)
  default = {
    0 = "frontend"
    1 = "backend"
    2 = "database"
  }
}

variable "startup_scripts" {
  description = "Startup scripts to assign based on instance role"
  type        = map(string)
  default     = {}
}

variable "ssh_username" {
  default = ""
}