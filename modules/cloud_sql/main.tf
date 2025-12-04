# Cloud SQL Module - GCP Best Practices Implementation
# This module creates a secure, highly available Cloud SQL instance with proper networking and monitoring

##############################################################
# 🔑 Random password generation for database
##############################################################
resource "random_password" "db_password" {
  count   = var.generate_random_password ? 1 : 0
  length  = 16
  special = true
}

##############################################################
# 🔐 Cloud KMS key for Cloud SQL encryption (with unique suffix)
##############################################################
resource "random_id" "kms_suffix" {
  byte_length = 2
}

resource "google_kms_key_ring" "cloudsql" {
  count    = var.create_kms_key ? 1 : 0
  name     = "${var.instance_name}-keyring-${random_id.kms_suffix.hex}"
  location = var.region
  project  = var.project_id

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "cloudsql" {
  count           = var.create_kms_key ? 1 : 0
  name            = "${var.instance_name}-key"
  key_ring        = google_kms_key_ring.cloudsql[0].id
  rotation_period = var.kms_key_rotation_period

  lifecycle {
    prevent_destroy = false
  }
}

##############################################################
# 🧑‍💼 Service account for Cloud SQL
##############################################################
resource "google_service_account" "cloudsql" {
  count        = var.create_service_account ? 1 : 0
  account_id   = "${var.instance_name}-sa"
  display_name = "Service Account for Cloud SQL ${var.instance_name}"
  project      = var.project_id
}

##############################################################
# 🔓 IAM binding for KMS encryption
##############################################################
##############################################################
# 🔐 Cloud SQL API & KMS Access Configuration (Final Fix)
##############################################################

# 1️⃣ Enable Cloud SQL Admin API
resource "google_project_service" "sqladmin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
}

# 2️⃣ Explicitly create (or get) the Cloud SQL Service Identity
# This forces Google to create: service-<project-number>@gcp-sa-cloud-sql.iam.gserviceaccount.com
# NOTE: This resource requires the google-beta provider
resource "google_project_service_identity" "cloudsql_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"

  depends_on = [google_project_service.sqladmin]
}

# 3️⃣ Grant the Cloud SQL service account permission to use the KMS key
resource "google_kms_crypto_key_iam_member" "cloudsql_kms" {
  count         = var.create_kms_key ? 1 : 0
  crypto_key_id = google_kms_crypto_key.cloudsql[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"

  depends_on = [
    google_kms_crypto_key.cloudsql,
    google_project_service_identity.cloudsql_sa
  ]
}

##############################################################
# 📦 Get project data
##############################################################
data "google_project" "project" {
  project_id = var.project_id
}

##############################################################
# 🔌 Private Service Access (PSA) for Cloud SQL
##############################################################

# Enable Service Networking API for this project (if not already enabled)
resource "google_project_service" "service_networking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

# Reserve an internal IP range in the VPC specifically for Google-managed services
resource "google_compute_global_address" "private_service_range" {
  name          = "${var.instance_name}-private-service-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network
  project       = var.project_id

  depends_on = [
    google_project_service.service_networking
  ]
}

# Create the private VPC connection for this VPC and PSA range
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.private_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_range.name]
  
  # ✅ ADD THIS LINE - Prevents orphaned peering during destroy
  deletion_policy = "ABANDON"

  depends_on = [
    google_project_service.service_networking,
    google_compute_global_address.private_service_range
  ]
}

##############################################################
# 🗄️ Cloud SQL Instance
##############################################################
resource "google_sql_database_instance" "this" {
  count            = var.create_instance ? 1 : 0
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region
  project          = var.project_id

  settings {
    tier                  = var.tier
    availability_type     = var.availability_type
    disk_type             = var.disk_type
    disk_size             = var.disk_size
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit

    # Backup configuration
    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
      transaction_log_retention_days = var.transaction_log_retention_days
      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = var.retention_unit
      }
    }

    # IP configuration
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    # Maintenance window
    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    # Database flags
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    # Insights config
    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_string_length     = var.query_string_length
      record_application_tags = var.record_application_tags
      record_client_address   = var.record_client_address
    }

    # Deletion protection
    deletion_protection_enabled = var.deletion_protection

    # User labels
    user_labels = var.labels
  }

  # Encryption configuration
  encryption_key_name = var.create_kms_key ? google_kms_crypto_key.cloudsql[0].id : var.encryption_key_name

  deletion_protection = var.deletion_protection

  depends_on = [
    google_kms_crypto_key_iam_member.cloudsql_kms,
    google_service_networking_connection.private_vpc_connection
  ]

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }
}

##############################################################
# 📚 Database creation
##############################################################
resource "google_sql_database" "databases" {
  for_each = var.create_instance ? var.databases : {}

  name      = each.value.name
  instance  = google_sql_database_instance.this[0].name
  charset   = lookup(each.value, "charset", null)
  collation = lookup(each.value, "collation", null)
  project   = var.project_id
}

##############################################################
# 👤 Root user password (if password policy is enabled)
##############################################################
resource "random_password" "root_password" {
  count   = var.enable_password_policy ? 1 : 0
  length  = 16
  special = true

  # Ensure it meets complexity requirements
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "google_sql_user" "root" {
  count    = var.enable_password_policy && var.create_instance ? 1 : 0
  name     = "root"
  instance = google_sql_database_instance.this[0].name
  password = random_password.root_password[0].result
  host     = "%"
  project  = var.project_id

  depends_on = [google_sql_database_instance.this]
}

##############################################################
# 👤 User creation
##############################################################
resource "google_sql_user" "users" {
  for_each = var.create_instance ? var.users : {}

  name     = each.value.name
  instance = google_sql_database_instance.this[0].name
  password = each.value.password != null ? each.value.password : (var.generate_random_password ? random_password.db_password[0].result : null)
  host     = lookup(each.value, "host", "%")
  project  = var.project_id

  dynamic "password_policy" {
    for_each = lookup(each.value, "enable_password_policy", false) ? [1] : []
    content {
      allowed_failed_attempts      = lookup(each.value, "allowed_failed_attempts", 5)
      password_expiration_duration = lookup(each.value, "password_expiration_duration", null)
      enable_failed_attempts_check = lookup(each.value, "enable_failed_attempts_check", true)
      enable_password_verification = lookup(each.value, "enable_password_verification", true)
    }
  }
}

##############################################################
# 🔁 Read Replicas
##############################################################
resource "google_sql_database_instance" "replicas" {
  count                = var.create_read_replica ? var.replica_count : 0
  name                 = "${var.instance_name}-replica-${count.index + 1}"
  database_version     = var.database_version
  region               = var.replica_region != null ? var.replica_region : var.region
  project              = var.project_id
  master_instance_name = google_sql_database_instance.this[0].name

  replica_configuration {
    failover_target = var.replica_failover_target
  }

  settings {
    tier              = var.replica_tier != null ? var.replica_tier : var.tier
    availability_type = var.replica_availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    disk_autoresize   = var.disk_autoresize

    ip_configuration {
      ipv4_enabled    = var.replica_ipv4_enabled
      private_network = var.private_network
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_string_length     = var.query_string_length
      record_application_tags = var.record_application_tags
      record_client_address   = var.record_client_address
    }

    user_labels = merge(var.labels, { replica = "true" })
  }

  deletion_protection = var.replica_deletion_protection

  depends_on = [google_sql_database_instance.this]
}

##############################################################
# 📈 Monitoring alert policies
##############################################################

resource "google_monitoring_alert_policy" "cpu_utilization" {
  count        = var.create_monitoring_alerts ? 1 : 0
  display_name = "${var.instance_name}-cpu-utilization"
  combiner     = "OR"
  project      = var.project_id

  conditions {
    display_name = "CPU Utilization over ${var.cpu_utilization_threshold}%"
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project_id}:${google_sql_database_instance.this[0].name}\" AND metric.type = \"cloudsql.googleapis.com/database/cpu/utilization\""
      duration        = "${var.alert_evaluation_period}s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_utilization_threshold / 100

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "86400s"
  }
}

resource "google_monitoring_alert_policy" "memory_utilization" {
  count        = var.create_monitoring_alerts ? 1 : 0
  display_name = "${var.instance_name}-memory-utilization"
  combiner     = "OR"
  project      = var.project_id

  conditions {
    display_name = "Memory Utilization over ${var.memory_utilization_threshold}%"
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project_id}:${google_sql_database_instance.this[0].name}\" AND metric.type = \"cloudsql.googleapis.com/database/memory/utilization\""
      duration        = "${var.alert_evaluation_period}s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.memory_utilization_threshold / 100

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "86400s"
  }
}

resource "google_monitoring_alert_policy" "disk_utilization" {
  count        = var.create_monitoring_alerts ? 1 : 0
  display_name = "${var.instance_name}-disk-utilization"
  combiner     = "OR"
  project      = var.project_id

  conditions {
    display_name = "Disk Utilization over ${var.disk_utilization_threshold}%"
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project_id}:${google_sql_database_instance.this[0].name}\" AND metric.type = \"cloudsql.googleapis.com/database/disk/utilization\""
      duration        = "${var.alert_evaluation_period}s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.disk_utilization_threshold / 100

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "86400s"
  }
}

resource "google_monitoring_alert_policy" "connections" {
  count        = var.create_monitoring_alerts ? 1 : 0
  display_name = "${var.instance_name}-connections"
  combiner     = "OR"
  project      = var.project_id

  conditions {
    display_name = "Database Connections over ${var.connections_threshold}"
    condition_threshold {
      filter          = "resource.type = \"cloudsql_database\" AND resource.labels.database_id = \"${var.project_id}:${google_sql_database_instance.this[0].name}\" AND metric.type = \"cloudsql.googleapis.com/database/network/connections\""
      duration        = "${var.alert_evaluation_period}s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.connections_threshold

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "86400s"
  }
}


  