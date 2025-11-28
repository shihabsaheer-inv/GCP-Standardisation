terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  enabled = var.enable_memorystore

  # Engine selectors with toggle applied
  is_redis_classic = local.enabled && upper(var.engine_type) == "REDIS"
  is_cluster       = local.enabled && upper(var.engine_type) == "REDIS_CLUSTER"
  is_memcached     = local.enabled && upper(var.engine_type) == "MEMCACHED"
}

# ---------------------------------------------------------------------------
# REDIS CLASSIC (google_redis_instance)
# ---------------------------------------------------------------------------
resource "google_redis_instance" "redis_instance" {
  count = local.is_redis_classic ? 1 : 0

  name           = var.instance_id
  project        = var.project_id
  region         = var.region

  tier           = var.tier
  memory_size_gb = var.memory_size_gb
  redis_version  = var.redis_version

  authorized_network      = var.vpc_self_link
  connect_mode            = var.connect_mode
  transit_encryption_mode = var.transit_encryption_mode

  read_replicas_mode = var.read_replicas_mode
  replica_count      = var.replica_count

  maintenance_policy {
    weekly_maintenance_window {
      day = var.maintenance_day
      start_time {
        hours   = var.maintenance_start_hour
        minutes = 0
      }
    }
  }

  labels = var.labels
}

# ---------------------------------------------------------------------------
# REDIS CLUSTER (google_redis_cluster)
# Provider v7.11.0 supports only: name, project, region, shard_count, replica_count, psc_configs
# ---------------------------------------------------------------------------
resource "google_redis_cluster" "redis_cluster" {
  count = local.is_cluster ? 1 : 0

  name    = var.instance_id
  project = var.project_id
  region  = var.region

  shard_count   = var.shard_count
  replica_count = var.cluster_replica_count

  dynamic "psc_configs" {
    for_each = var.psc_networks
    content {
      network = psc_configs.value
    }
  }
}

# ---------------------------------------------------------------------------
# MEMCACHED (google_memcache_instance)
# ---------------------------------------------------------------------------
resource "google_memcache_instance" "memcached" {
  count = local.is_memcached ? 1 : 0

  name    = var.instance_id
  project = var.project_id
  region  = var.region

  display_name = var.display_name

  node_count = var.memcached_node_count

  node_config {
    cpu_count      = var.memcached_cpu
    memory_size_mb = var.memcached_memory_mb
  }

  authorized_network = var.vpc_self_link
  labels             = var.labels
}
