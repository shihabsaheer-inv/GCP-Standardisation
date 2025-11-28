# ═════════════════════════════════════════════════════════════════════════════
# GKE MODULE VARIABLES
# ═════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────
# 🎮 CONTROL VARIABLES
# ─────────────────────────────
variable "create_cluster" {
  description = "Whether to create the GKE cluster"
  type        = bool
  default     = true
}

variable "create_node_pool" {
  description = "Whether to create node pools"
  type        = bool
  default     = true
}

# ─────────────────────────────
# 🌐 BASIC CLUSTER CONFIGURATION
# ─────────────────────────────
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "The location (region or zone) of the cluster"
  type        = string
}

variable "remove_default_node_pool" {
  description = "Remove the default node pool while creating the cluster"
  type        = bool
  default     = true
}

variable "initial_node_count" {
  description = "The initial node count for the default pool"
  type        = number
  default     = 1
}

variable "min_master_version" {
  description = "The minimum version of the master"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔗 NETWORKING CONFIGURATION
# ─────────────────────────────
variable "network_self_link" {
  description = "The VPC network self link"
  type        = string
}

variable "subnetwork_self_link" {
  description = "The subnetwork self link"
  type        = string
}

variable "networking_mode" {
  description = "Determines whether alias IPs or routes will be used for pod IPs"
  type        = string
  default     = "VPC_NATIVE"
}

variable "cluster_secondary_range_name" {
  description = "The name of the secondary range for pods"
  type        = string
  default     = ""
}

variable "services_secondary_range_name" {
  description = "The name of the secondary range for services"
  type        = string
  default     = ""
}

# ─────────────────────────────
# 🔒 PRIVATE CLUSTER CONFIGURATION
# ─────────────────────────────
variable "enable_private_cluster" {
  description = "Enable private cluster configuration"
  type        = bool
  default     = true
}

variable "enable_private_nodes" {
  description = "Enable private nodes (nodes have only private IP addresses)"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint (cluster endpoint is private)"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation for the master network"
  type        = string
  default     = "172.16.0.0/28"
}

variable "enable_master_global_access" {
  description = "Whether master is accessible globally or only from the same region"
  type        = bool
  default     = false
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = optional(string)
  }))
  default = []
}

# ─────────────────────────────
# 🔐 SECURITY & IDENTITY
# ─────────────────────────────
variable "enable_workload_identity" {
  description = "Enable Workload Identity"
  type        = bool
  default     = true
}

variable "enable_binary_authorization" {
  description = "Enable Binary Authorization"
  type        = bool
  default     = false
}

variable "binary_authorization_evaluation_mode" {
  description = "Mode of operation for Binary Authorization"
  type        = string
  default     = "PROJECT_SINGLETON_POLICY_ENFORCE"
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded GKE Nodes"
  type        = bool
  default     = true
}

variable "enable_secure_boot" {
  description = "Enable Secure Boot for shielded nodes"
  type        = bool
  default     = false
}

variable "enable_integrity_monitoring" {
  description = "Enable Integrity Monitoring for shielded nodes"
  type        = bool
  default     = true
}

variable "enable_database_encryption" {
  description = "Enable application-layer secrets encryption"
  type        = bool
  default     = false
}

variable "database_encryption_key_name" {
  description = "The Cloud KMS key name for database encryption"
  type        = string
  default     = ""
}

variable "enable_security_posture" {
  description = "Enable security posture management"
  type        = bool
  default     = false
}

variable "security_posture_mode" {
  description = "Security posture mode (BASIC or ENTERPRISE)"
  type        = string
  default     = "BASIC"
}

variable "security_posture_vulnerability_mode" {
  description = "Vulnerability mode (VULNERABILITY_DISABLED, VULNERABILITY_BASIC, VULNERABILITY_ENTERPRISE)"
  type        = string
  default     = "VULNERABILITY_DISABLED"
}

# ─────────────────────────────
# 🔌 ADDONS & FEATURES
# ─────────────────────────────
variable "enable_http_load_balancing" {
  description = "Enable HTTP Load Balancing addon"
  type        = bool
  default     = true
}

variable "enable_horizontal_pod_autoscaling" {
  description = "Enable Horizontal Pod Autoscaling addon"
  type        = bool
  default     = true
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable Vertical Pod Autoscaling"
  type        = bool
  default     = false
}

variable "enable_network_policy" {
  description = "Enable network policy addon"
  type        = bool
  default     = false
}

variable "network_policy_provider" {
  description = "The network policy provider (CALICO or PROVIDER_UNSPECIFIED)"
  type        = string
  default     = "PROVIDER_UNSPECIFIED"
}

variable "enable_filestore_csi_driver" {
  description = "Enable Filestore CSI driver"
  type        = bool
  default     = false
}

variable "enable_gcs_fuse_csi_driver" {
  description = "Enable GCS Fuse CSI driver"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔄 MAINTENANCE & RELEASE
# ─────────────────────────────
variable "enable_maintenance_policy" {
  description = "Enable maintenance policy"
  type        = bool
  default     = true
}

variable "maintenance_window_type" {
  description = "Type of maintenance window (daily or recurring)"
  type        = string
  default     = "daily"
}

variable "maintenance_start_time" {
  description = "Start time for daily maintenance window (HH:MM format)"
  type        = string
  default     = "03:00"
}

variable "maintenance_recurrence_start_time" {
  description = "Start time for recurring maintenance window (RFC3339 format)"
  type        = string
  default     = ""
}

variable "maintenance_recurrence_end_time" {
  description = "End time for recurring maintenance window (RFC3339 format)"
  type        = string
  default     = ""
}

variable "maintenance_recurrence" {
  description = "Recurrence rule for maintenance (RRULE format)"
  type        = string
  default     = ""
}

variable "release_channel" {
  description = "Release channel (RAPID, REGULAR, STABLE, or UNSPECIFIED)"
  type        = string
  default     = "REGULAR"
}

# ─────────────────────────────
# 📊 MONITORING & LOGGING
# ─────────────────────────────
variable "enable_monitoring_config" {
  description = "Enable monitoring configuration"
  type        = bool
  default     = true
}

variable "monitoring_enable_components" {
  description = "List of monitoring components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS"]
}

variable "enable_managed_prometheus" {
  description = "Enable managed Prometheus"
  type        = bool
  default     = false
}

variable "enable_logging_config" {
  description = "Enable logging configuration"
  type        = bool
  default     = true
}

variable "logging_enable_components" {
  description = "List of logging components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "enable_resource_usage_export" {
  description = "Enable resource usage export to BigQuery"
  type        = bool
  default     = false
}

variable "enable_network_egress_metering" {
  description = "Enable network egress metering"
  type        = bool
  default     = false
}

variable "enable_resource_consumption_metering" {
  description = "Enable resource consumption metering"
  type        = bool
  default     = true
}

variable "resource_usage_export_dataset_id" {
  description = "BigQuery dataset ID for resource usage export"
  type        = string
  default     = ""
}

# ─────────────────────────────
# 🎯 CLUSTER AUTOSCALING
# ─────────────────────────────
variable "enable_cluster_autoscaling" {
  description = "Enable cluster autoscaling"
  type        = bool
  default     = false
}

variable "autoscaling_profile" {
  description = "Autoscaling profile (BALANCED or OPTIMIZE_UTILIZATION)"
  type        = string
  default     = "BALANCED"
}

variable "autoscaling_resource_limits" {
  description = "Resource limits for cluster autoscaling"
  type = list(object({
    resource_type = string
    minimum       = number
    maximum       = number
  }))
  default = []
}

# ─────────────────────────────
# 🖥️ NODE POOL CONFIGURATION
# ─────────────────────────────
variable "node_pools" {
  description = "Map of node pool configurations"
  type        = any
  default     = {}
}

variable "node_pool_initial_node_count" {
  description = "Initial node count for node pools"
  type        = number
  default     = 1
}

variable "node_pool_min_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "node_pool_max_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
  default     = 3
}

variable "node_pool_location_policy" {
  description = "Location policy for node pool (BALANCED or ANY)"
  type        = string
  default     = "BALANCED"
}

variable "node_pool_machine_type" {
  description = "Machine type for node pool"
  type        = string
  default     = "e2-medium"
}

variable "node_pool_disk_size_gb" {
  description = "Disk size in GB for node pool"
  type        = number
  default     = 100
}

variable "node_pool_disk_type" {
  description = "Disk type for node pool (pd-standard or pd-ssd)"
  type        = string
  default     = "pd-standard"
}

variable "node_pool_image_type" {
  description = "Image type for node pool (COS_CONTAINERD, UBUNTU_CONTAINERD, etc.)"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "node_pool_preemptible" {
  description = "Whether to use preemptible nodes"
  type        = bool
  default     = false
}

variable "node_pool_spot" {
  description = "Whether to use spot instances"
  type        = bool
  default     = false
}

variable "node_service_account" {
  description = "Service account for nodes"
  type        = string
  default     = ""
}

variable "node_oauth_scopes" {
  description = "OAuth scopes for nodes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "node_pool_labels" {
  description = "Labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "node_pool_tags" {
  description = "Network tags to apply to nodes"
  type        = list(string)
  default     = []
}

variable "node_pool_metadata" {
  description = "Metadata to apply to nodes"
  type        = map(string)
  default = {
    disable-legacy-endpoints = "true"
  }
}

variable "enable_gcfs" {
  description = "Enable Google Container File System (image streaming)"
  type        = bool
  default     = false
}

# ─────────────────────────────
# 🔧 NODE POOL MANAGEMENT
# ─────────────────────────────
variable "auto_repair" {
  description = "Enable auto repair for nodes"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto upgrade for nodes"
  type        = bool
  default     = true
}

variable "enable_surge_upgrade" {
  description = "Enable surge upgrade settings"
  type        = bool
  default     = true
}

variable "max_surge" {
  description = "Maximum number of nodes that can be created during upgrade"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Maximum number of nodes that can be unavailable during upgrade"
  type        = number
  default     = 0
}

variable "upgrade_strategy" {
  description = "Strategy for node pool upgrade (SURGE or BLUE_GREEN)"
  type        = string
  default     = "SURGE"
}

variable "node_pool_soak_duration" {
  description = "Soak time after node becomes ready (for BLUE_GREEN)"
  type        = string
  default     = "0s"
}

variable "batch_percentage" {
  description = "Percentage of nodes to upgrade in a batch (for BLUE_GREEN)"
  type        = number
  default     = null
}

variable "batch_node_count" {
  description = "Number of nodes to upgrade in a batch (for BLUE_GREEN)"
  type        = number
  default     = null
}

variable "batch_soak_duration" {
  description = "Soak time after batch upgrade (for BLUE_GREEN)"
  type        = string
  default     = "0s"
}

# ─────────────────────────────
# ⏱️ TIMEOUTS
# ─────────────────────────────
variable "cluster_create_timeout" {
  description = "Timeout for cluster creation"
  type        = string
  default     = "45m"
}

variable "cluster_update_timeout" {
  description = "Timeout for cluster updates"
  type        = string
  default     = "45m"
}

variable "cluster_delete_timeout" {
  description = "Timeout for cluster deletion"
  type        = string
  default     = "45m"
}

variable "node_pool_create_timeout" {
  description = "Timeout for node pool creation"
  type        = string
  default     = "30m"
}

variable "node_pool_update_timeout" {
  description = "Timeout for node pool updates"
  type        = string
  default     = "30m"
}

variable "node_pool_delete_timeout" {
  description = "Timeout for node pool deletion"
  type        = string
  default     = "30m"
}

variable "gke_network_self_link" {
  type = string
}

variable "gke_subnetwork_self_link" {
  type = string
}
