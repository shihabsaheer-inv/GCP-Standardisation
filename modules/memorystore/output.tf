output "redis_instance_id" {
  value = try(google_redis_instance.redis_instance[0].id, null)
}

output "redis_cluster_id" {
  value = try(google_redis_cluster.redis_cluster[0].id, null)
}

output "endpoint" {
  value = try(
    google_redis_instance.redis_instance[0].host,
    google_memcache_instance.memcached[0].discovery_endpoint,
    null
  )
}


###############################################################################
# Memcached
###############################################################################

output "memcached_id" {
  value = try(google_memcache_instance.memcached[0].id, null)
}

output "memcached_discovery_endpoint" {
  value = try(google_memcache_instance.memcached[0].discovery_endpoint, null)
}

output "memcached_hosts" {
  value = try(
    [for n in google_memcache_instance.memcached[0].memcache_nodes : n.host],
    null
  )
}

output "memcached_ports" {
  value = try(
    [for n in google_memcache_instance.memcached[0].memcache_nodes : n.port],
    null
  )
}
