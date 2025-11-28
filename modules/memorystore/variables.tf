variable "enable_memorystore" {
  type        = bool
  description = "Enable or disable memorystore resources"
  default     = true
}

variable "engine_type" {
  type        = string
  description = "REDIS | REDIS_CLUSTER | MEMCACHED"
  default     = "REDIS"
}

variable "project_id" { type = string }
variable "instance_id" { type = string }
variable "display_name" { 
  type = string 
  default = null 
  }
variable "region" { 
  type = string 
  default = "us-central1" 
  }

# Redis Classic
variable "tier" { 
  type = string 
  default = "STANDARD_HA" 
  }
variable "memory_size_gb" { 
  type = number 
  default = 1 
  }

variable "redis_version" { 
  type = string 
  default = "REDIS_7_0" 
  }

variable "vpc_self_link" { 
  type = string 
  }
variable "connect_mode" { 
  type = string 
  default = "PRIVATE_SERVICE_ACCESS" 
  }

variable "transit_encryption_mode" { 
  type = string 
  default = "SERVER_AUTHENTICATION" 
  }

variable "read_replicas_mode" { 
  type = string 
  default = "DISABLED" 
  }
variable "replica_count" { 
  type = number 
  default = 0 
  }

# Redis Cluster
variable "shard_count" {
  type        = number
  default     = 3
  description = "Number of shards for redis cluster"
}

variable "cluster_replica_count" {
  type        = number
  default     = 1
}

variable "psc_networks" {
  type        = list(string)
  default     = []
}

# Memcached
variable "memcached_node_count" { 
  type = number 
  default = 1 
  }
variable "memcached_cpu" { 
  type = number 
  default = 1 
  }
variable "memcached_memory_mb" { 
  type = number 
  default = 1024 
  }

# Maintenance
variable "maintenance_day" { 
  type = string 
  default = "SUNDAY" 
  }
variable "maintenance_start_hour" { 
  type = number 
  default = 3 
  }

# Labels
variable "labels" {
  type    = map(string)
  default = {}
}
