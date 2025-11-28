output "url_map" {
  value = try(google_compute_url_map.cdn_url_map[0].self_link, null)
}

output "backend_bucket" {
  value = try(google_compute_backend_bucket.cdn_bucket[0].self_link, null)
}

output "backend_service" {
  value = try(google_compute_backend_service.cdn_backend[0].self_link, null)
}

output "forwarding_rule_ip" {
  value = try(google_compute_global_forwarding_rule.cdn_forwarding_rule[0].ip_address, null)
}
