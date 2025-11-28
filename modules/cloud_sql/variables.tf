# Cloud SQL Module Variables - Comprehensive Configuration Options

# General Configuration
variable "create_instance" {
  description = "Whether to create the Cloud SQL instance"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for Cloud SQL instance"
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "The database version (e.g., MYSQL_8_0, POSTGRES_15, SQLSERVER_2019_STANDARD)"
  type        = string
  default     = "MYSQL_8_0"

  validation {
    condition     = can(regex("^(MYSQL|POSTGRES|SQLSERVER)", var.database_version))
    error_message = "Database version must be a valid Cloud SQL database version."
  }
}

variable "tier" {
  description = "The machine type for the instance (e.g., db-f1-micro, db-n1-standard-1)"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "The availability type (ZONAL or REGIONAL for HA)"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], var.availability_type)
    error_message = "Availability type must be either ZONAL or REGIONAL."
  }
}

# Storage Configuration
variable "disk_type" {
  description = "The disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD"], var.disk_type)
    error_message = "Disk type must be either PD_SSD or PD_HDD."
  }
}

variable "disk_size" {
  description = "The size of data disk in GB"
  type        = number
  default     = 10
}

variable "disk_autoresize" {
  description = "Whether to enable automatic storage increase"
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased"
  type        = number
  default     = 100
}

# Backup Configuration
variable "backup_enabled" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "HH:MM format time indicating when backup should start"
  type        = string
  default     = "03:00"
}

variable "point_in_time_recovery_enabled" {
  description = "Whether point-in-time recovery is enabled"
  type        = bool
  default     = true
}

variable "transaction_log_retention_days" {
  description = "The number of days to retain transaction logs (1-7)"
  type        = number
  default     = 7

  validation {
    condition     = var.transaction_log_retention_days >= 1 && var.transaction_log_retention_days <= 7
    error_message = "Transaction log retention days must be between 1 and 7."
  }
}

variable "retained_backups" {
  description = "Number of backups to retain"
  type        = number
  default     = 7
}

variable "retention_unit" {
  description = "The unit for retained_backups (COUNT)"
  type        = string
  default     = "COUNT"
}

# Network Configuration
variable "ipv4_enabled" {
  description = "Whether the instance should be assigned a public IP address"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "The VPC network from which the Cloud SQL instance is accessible"
  type        = string
  default     = null
}

variable "require_ssl" {
  description = "Whether SSL connections over IP are enforced"
  type        = bool
  default     = true
}

variable "authorized_networks" {
  description = "List of authorized networks that can access the instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Maintenance Configuration
variable "maintenance_window_day" {
  description = "Day of week for maintenance window (1-7, 1 = Monday)"
  type        = number
  default     = 7

  validation {
    condition     = var.maintenance_window_day >= 1 && var.maintenance_window_day <= 7
    error_message = "Maintenance window day must be between 1 and 7."
  }
}

variable "maintenance_window_hour" {
  description = "Hour of day for maintenance window (0-23)"
  type        = number
  default     = 5

  validation {
    condition     = var.maintenance_window_hour >= 0 && var.maintenance_window_hour <= 23
    error_message = "Maintenance window hour must be between 0 and 23."
  }
}

variable "maintenance_window_update_track" {
  description = "Receive updates earlier (canary) or later (stable)"
  type        = string
  default     = "stable"

  validation {
    condition     = contains(["canary", "stable"], var.maintenance_window_update_track)
    error_message = "Update track must be either canary or stable."
  }
}

# Database Flags
variable "database_flags" {
  description = "List of database flags to set on the instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Query Insights Configuration
variable "query_insights_enabled" {
  description = "Whether Query Insights feature is enabled"
  type        = bool
  default     = true
}

variable "query_string_length" {
  description = "Maximum query length stored in bytes"
  type        = number
  default     = 1024
}

variable "record_application_tags" {
  description = "Whether to record application tags for each query"
  type        = bool
  default     = false
}

variable "record_client_address" {
  description = "Whether to record client address for each query"
  type        = bool
  default     = false
}

# Password Policy Configuration
variable "enable_password_policy" {
  description = "Whether to enable password validation policy"
  type        = bool
  default     = true
}

variable "password_policy_min_length" {
  description = "Minimum password length"
  type        = number
  default     = 12
}

variable "password_policy_complexity" {
  description = "Password complexity (COMPLEXITY_DEFAULT or COMPLEXITY_UNSPECIFIED)"
  type        = string
  default     = "COMPLEXITY_DEFAULT"
}

variable "password_policy_reuse_interval" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 5
}

variable "password_policy_disallow_username" {
  description = "Whether username is disallowed in password"
  type        = bool
  default     = true
}

# Deletion Protection
variable "deletion_protection" {
  description = "Whether the instance is protected from deletion"
  type        = bool
  default     = false
}

# Encryption Configuration
variable "create_kms_key" {
  description = "Whether to create a KMS key for encryption"
  type        = bool
  default     = true
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for CMEK disk encryption"
  type        = string
  default     = null
}

variable "kms_key_rotation_period" {
  description = "Rotation period for KMS key (e.g., 7776000s for 90 days)"
  type        = string
  default     = "7776000s"
}

# Service Account Configuration
variable "create_service_account" {
  description = "Whether to create a service account for Cloud SQL"
  type        = bool
  default     = false
}

# Database and User Configuration
variable "databases" {
  description = "Map of databases to create"
  type = map(object({
    name      = string
    charset   = optional(string)
    collation = optional(string)
  }))
  default = {}
}

variable "users" {
  description = "Map of users to create"
  type = map(object({
    name                         = string
    password                     = optional(string)
    host                         = optional(string)
    enable_password_policy       = optional(bool, false)
    allowed_failed_attempts      = optional(number, 5)
    password_expiration_duration = optional(string)
    enable_failed_attempts_check = optional(bool, true)
    enable_password_verification = optional(bool, true)
  }))
  default = {}
}

variable "generate_random_password" {
  description = "Whether to generate a random password for users without a password"
  type        = bool
  default     = true
}

# Read Replica Configuration
variable "create_read_replica" {
  description = "Whether to create read replicas"
  type        = bool
  default     = false
}

variable "replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = 1
}

variable "replica_tier" {
  description = "The machine type for read replicas (defaults to main instance tier)"
  type        = string
  default     = null
}

variable "replica_region" {
  description = "The region for read replicas (defaults to main instance region)"
  type        = string
  default     = null
}

variable "replica_availability_type" {
  description = "The availability type for replicas"
  type        = string
  default     = "ZONAL"
}

variable "replica_ipv4_enabled" {
  description = "Whether replicas should have public IP"
  type        = bool
  default     = false
}

variable "replica_failover_target" {
  description = "Whether the replica is a failover target"
  type        = bool
  default     = false
}

variable "replica_deletion_protection" {
  description = "Whether replicas are protected from deletion"
  type        = bool
  default     = false
}

# Monitoring and Alerting Configuration
variable "create_monitoring_alerts" {
  description = "Whether to create monitoring alert policies"
  type        = bool
  default     = true
}

variable "cpu_utilization_threshold" {
  description = "CPU utilization threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "memory_utilization_threshold" {
  description = "Memory utilization threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "disk_utilization_threshold" {
  description = "Disk utilization threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "connections_threshold" {
  description = "Database connections threshold for alerts"
  type        = number
  default     = 80
}

variable "alert_evaluation_period" {
  description = "Alert evaluation period in seconds"
  type        = number
  default     = 300
}

variable "notification_channels" {
  description = "List of notification channel IDs for alerts"
  type        = list(string)
  default     = []
}

# Labels/Tags
variable "labels" {
  description = "A map of labels to assign to the resources"
  type        = map(string)
  default     = {}
}
