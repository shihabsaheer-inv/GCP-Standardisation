# ═════════════════════════════════════════════════════════════════════════════
# GKE CLUSTER MODULE
# ═════════════════════════════════════════════════════════════════════════════

# GKE Cluster
resource "google_container_cluster" "primary" {
  count    = var.create_cluster ? 1 : 0
  name     = var.cluster_name
  location = var.cluster_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  # Networking configuration
  networking_mode = var.networking_mode

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # Private cluster configuration
  dynamic "private_cluster_config" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      enable_private_nodes    = var.enable_private_nodes
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block

      dynamic "master_global_access_config" {
        for_each = var.enable_master_global_access ? [1] : []
        content {
          enabled = true
        }
      }
    }
  }

  # Master authorized networks
  dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
    }
  }

  # Workload Identity
  dynamic "workload_identity_config" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }

  # Binary Authorization
  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [1] : []
    content {
      evaluation_mode = var.binary_authorization_evaluation_mode
    }
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = !var.enable_http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.enable_horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.enable_network_policy
    }

    gcp_filestore_csi_driver_config {
      enabled = var.enable_filestore_csi_driver
    }

    gcs_fuse_csi_driver_config {
      enabled = var.enable_gcs_fuse_csi_driver
    }
  }

  # Vertical Pod Autoscaling
  dynamic "vertical_pod_autoscaling" {
    for_each = var.enable_vertical_pod_autoscaling ? [1] : []
    content {
      enabled = true
    }
  }

  # Network Policy
  dynamic "network_policy" {
    for_each = var.enable_network_policy ? [1] : []
    content {
      enabled  = true
      provider = var.network_policy_provider
    }
  }

  # Maintenance Policy
  dynamic "maintenance_policy" {
    for_each = var.enable_maintenance_policy ? [1] : []
    content {
      dynamic "daily_maintenance_window" {
        for_each = var.maintenance_window_type == "daily" ? [1] : []
        content {
          start_time = var.maintenance_start_time
        }
      }

      dynamic "recurring_window" {
        for_each = var.maintenance_window_type == "recurring" ? [1] : []
        content {
          start_time = var.maintenance_recurrence_start_time
          end_time   = var.maintenance_recurrence_end_time
          recurrence = var.maintenance_recurrence
        }
      }
    }
  }

  # Release Channel
  dynamic "release_channel" {
    for_each = var.release_channel != null ? [1] : []
    content {
      channel = var.release_channel
    }
  }

  # Monitoring Config
  dynamic "monitoring_config" {
    for_each = var.enable_monitoring_config ? [1] : []
    content {
      enable_components = var.monitoring_enable_components

      dynamic "managed_prometheus" {
        for_each = var.enable_managed_prometheus ? [1] : []
        content {
          enabled = true
        }
      }
    }
  }

  # Logging Config
  dynamic "logging_config" {
    for_each = var.enable_logging_config ? [1] : []
    content {
      enable_components = var.logging_enable_components
    }
  }

  # Cluster Autoscaling
  dynamic "cluster_autoscaling" {
    for_each = var.enable_cluster_autoscaling ? [1] : []
    content {
      enabled = true
      dynamic "auto_provisioning_defaults" {
        for_each = var.autoscaling_profile != null ? [1] : []
        content {
          service_account = var.node_service_account
          oauth_scopes    = var.node_oauth_scopes

          management {
            auto_repair  = var.auto_repair
            auto_upgrade = var.auto_upgrade
          }
        }
      }

      dynamic "resource_limits" {
        for_each = var.autoscaling_resource_limits
        content {
          resource_type = resource_limits.value.resource_type
          minimum       = resource_limits.value.minimum
          maximum       = resource_limits.value.maximum
        }
      }

      autoscaling_profile = var.autoscaling_profile
    }
  }

  # Database Encryption
  dynamic "database_encryption" {
    for_each = var.enable_database_encryption ? [1] : []
    content {
      state    = "ENCRYPTED"
      key_name = var.database_encryption_key_name
    }
  }

  # Resource Usage Export
  dynamic "resource_usage_export_config" {
    for_each = var.enable_resource_usage_export ? [1] : []
    content {
      enable_network_egress_metering = var.enable_network_egress_metering
      enable_resource_consumption_metering = var.enable_resource_consumption_metering

      bigquery_destination {
        dataset_id = var.resource_usage_export_dataset_id
      }
    }
  }

  # Shielded Nodes
  dynamic "node_config" {
    for_each = var.enable_shielded_nodes ? [1] : []
    content {
      shielded_instance_config {
        enable_secure_boot          = var.enable_secure_boot
        enable_integrity_monitoring = var.enable_integrity_monitoring
      }
    }
  }

  # Security Posture Config
  dynamic "security_posture_config" {
    for_each = var.enable_security_posture ? [1] : []
    content {
      mode               = var.security_posture_mode
      vulnerability_mode = var.security_posture_vulnerability_mode
    }
  }

  min_master_version = var.min_master_version

  deletion_protection = var.deletion_protection

  lifecycle {
    ignore_changes = [
      node_config,
      initial_node_count,
    ]
  }

  timeouts {
    create = var.cluster_create_timeout
    update = var.cluster_update_timeout
    delete = var.cluster_delete_timeout
  }
}

# GKE Node Pool
resource "google_container_node_pool" "primary" {
  for_each = var.create_cluster && var.create_node_pool ? var.node_pools : {}

  name     = each.key
  location = var.cluster_location
  cluster  = google_container_cluster.primary[0].name

  initial_node_count = lookup(each.value, "initial_node_count", var.node_pool_initial_node_count)
  node_count         = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", null)

  # Autoscaling
  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [1] : []
    content {
      min_node_count       = lookup(each.value, "min_count", var.node_pool_min_count)
      max_node_count       = lookup(each.value, "max_count", var.node_pool_max_count)
      location_policy      = lookup(each.value, "location_policy", var.node_pool_location_policy)
      total_min_node_count = lookup(each.value, "total_min_node_count", null)
      total_max_node_count = lookup(each.value, "total_max_node_count", null)
    }
  }

  # Node Configuration
  node_config {
    machine_type = lookup(each.value, "machine_type", var.node_pool_machine_type)
    disk_size_gb = lookup(each.value, "disk_size_gb", var.node_pool_disk_size_gb)
    disk_type    = lookup(each.value, "disk_type", var.node_pool_disk_type)
    image_type   = lookup(each.value, "image_type", var.node_pool_image_type)

    preemptible  = lookup(each.value, "preemptible", var.node_pool_preemptible)
    spot         = lookup(each.value, "spot", var.node_pool_spot)

    service_account = var.node_service_account
    oauth_scopes    = var.node_oauth_scopes

    labels = merge(
      var.node_pool_labels,
      lookup(each.value, "labels", {})
    )

    tags = distinct(concat(
      var.node_pool_tags,
      lookup(each.value, "tags", [])
    ))

    metadata = merge(
      var.node_pool_metadata,
      lookup(each.value, "metadata", {})
    )

    # Taints
    dynamic "taint" {
      for_each = lookup(each.value, "taints", [])
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    # Workload Identity
    dynamic "workload_metadata_config" {
      for_each = var.enable_workload_identity ? [1] : []
      content {
        mode = "GKE_METADATA"
      }
    }

    # Shielded Instance Config
    dynamic "shielded_instance_config" {
      for_each = var.enable_shielded_nodes ? [1] : []
      content {
        enable_secure_boot          = var.enable_secure_boot
        enable_integrity_monitoring = var.enable_integrity_monitoring
      }
    }

    # GCE Instance Metadata
    dynamic "gcfs_config" {
      for_each = lookup(each.value, "enable_gcfs", var.enable_gcfs) ? [1] : []
      content {
        enabled = true
      }
    }

    # Local SSD (ephemeral storage)
    local_ssd_count = lookup(each.value, "local_ssd_count", 0)

    # GPU Configuration
    dynamic "guest_accelerator" {
      for_each = lookup(each.value, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type  = lookup(each.value, "accelerator_type", "")
        count = lookup(each.value, "accelerator_count", 0)
        gpu_driver_installation_config {
          gpu_driver_version = lookup(each.value, "gpu_driver_version", "DEFAULT")
        }
      }
    }
  }

  # Management
  management {
    auto_repair  = lookup(each.value, "auto_repair", var.auto_repair)
    auto_upgrade = lookup(each.value, "auto_upgrade", var.auto_upgrade)
  }

  # Upgrade Settings
  dynamic "upgrade_settings" {
    for_each = var.enable_surge_upgrade ? [1] : []
    content {
      max_surge       = var.max_surge
      max_unavailable = var.max_unavailable
      strategy        = var.upgrade_strategy

      dynamic "blue_green_settings" {
        for_each = var.upgrade_strategy == "BLUE_GREEN" ? [1] : []
        content {
          node_pool_soak_duration = var.node_pool_soak_duration

          standard_rollout_policy {
            batch_percentage    = var.batch_percentage
            batch_node_count    = var.batch_node_count
            batch_soak_duration = var.batch_soak_duration
          }
        }
      }
    }
  }

  timeouts {
    create = var.node_pool_create_timeout
    update = var.node_pool_update_timeout
    delete = var.node_pool_delete_timeout
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }

  depends_on = [google_container_cluster.primary]
}