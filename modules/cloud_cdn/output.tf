######################################
# Backend service (GCS or custom)
######################################
output "backend_service" {
  description = "The backend service used by the CDN (GCS NEG or custom NEG)."
  value = try(
    google_compute_backend_service.cdn_gcs_backend[0].self_link,
    google_compute_backend_service.cdn_backend[0].self_link,
    null
  )
}

######################################
# URL Map
######################################
output "url_map" {
  description = "The URL map for the CDN load balancer."
  value       = try(google_compute_url_map.cdn_url_map[0].self_link, null)
}

######################################
# Forwarding Rule IP (HTTPS or HTTP)
######################################
output "forwarding_rule_ip" {
  description = "The IP address of the CDN load balancer."
  value = try(
    google_compute_global_forwarding_rule.cdn_forwarding_rule_https[0].ip_address,
    google_compute_global_forwarding_rule.cdn_forwarding_rule_http[0].ip_address,
    null
  )
}

######################################
# Whether CDN is fully created
######################################
output "cdn_ready" {
  description = "Indicates whether the CDN backend is created."
  value = try(
    google_compute_backend_service.cdn_gcs_backend[0].id,
    google_compute_backend_service.cdn_backend[0].id,
    null
  )
}
