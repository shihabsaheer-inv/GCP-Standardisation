resource "google_compute_global_address" "lb_ip" {
  count = var.create_lb ? 1 : 0
  name  = "${var.lb_name}-ip"
}

# Backend (Cloud Run / NEG / MIG)
resource "google_compute_backend_service" "default" {
  count       = var.create_lb ? 1 : 0
  name        = "${var.lb_name}-backend"
  protocol    = var.backend_protocol
  timeout_sec = var.backend_timeout

  health_checks = [
    google_compute_health_check.default[0].self_link
  ]

  dynamic "backend" {
    for_each = var.negs
    content {
      group = backend.value
    }
  }

  dynamic "backend" {
    for_each = var.instance_groups
    content {
      group = backend.value
    }
  }

  enable_cdn = var.enable_cdn

  connection_draining_timeout_sec = var.connection_draining_timeout

  security_policy = var.cloud_armor_policy

  log_config {
    enable = var.enable_access_logs
  }
}

# URL Map
resource "google_compute_url_map" "default" {
  count           = var.create_lb ? 1 : 0
  name            = "${var.lb_name}-url-map"
  default_service = google_compute_backend_service.default[0].self_link
}

# HTTPS Target Proxy
resource "google_compute_target_https_proxy" "default" {
  count            = var.create_lb && var.create_https_listener ? 1 : 0
  name             = "${var.lb_name}-https-proxy"
  url_map          = google_compute_url_map.default[0].self_link
  ssl_certificates = var.ssl_certificates
}

# HTTP Target Proxy (for redirect or forward)
resource "google_compute_target_http_proxy" "redirect" {
  count   = var.create_lb && var.create_http_redirect ? 1 : 0
  name    = "${var.lb_name}-http-redirect"
  url_map = google_compute_url_map.default[0].self_link
}

# HTTPS Forwarding Rule
resource "google_compute_global_forwarding_rule" "https" {
  count       = var.create_lb && var.create_https_listener ? 1 : 0
  name        = "${var.lb_name}-https"
  target      = google_compute_target_https_proxy.default[0].self_link
  port_range  = "443"
  ip_address  = google_compute_global_address.lb_ip[0].address
  ip_protocol = "TCP"
}

# HTTP redirect forwarding rule
resource "google_compute_global_forwarding_rule" "http" {
  count       = var.create_lb && var.create_http_redirect ? 1 : 0
  name        = "${var.lb_name}-http"
  target      = google_compute_target_http_proxy.redirect[0].self_link
  port_range  = "80"
  ip_address  = google_compute_global_address.lb_ip[0].address
  ip_protocol = "TCP"
}

# Health Check
resource "google_compute_health_check" "default" {
  count = var.create_lb ? 1 : 0
  name  = "${var.lb_name}-hc"

  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_path
  }

  timeout_sec         = var.health_check_timeout
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
}
