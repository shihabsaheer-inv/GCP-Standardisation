output "lb_ip" {
  value       = var.create_lb ? google_compute_global_address.lb_ip[0].address : null
  description = "The global IP address of the load balancer"
}

output "https_forwarding_rule" {
  value = var.create_https_listener ? google_compute_global_forwarding_rule.https[0].self_link : null
}

output "http_forwarding_rule" {
  value = var.create_http_redirect ? google_compute_global_forwarding_rule.http[0].self_link : null
}

output "backend_service" {
  value = google_compute_backend_service.default[0].self_link
}
