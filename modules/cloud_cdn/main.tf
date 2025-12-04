locals {
  name_prefix = var.name != "" ? var.name : "cdn"
}

##############################
# GCS ORIGIN (Origin NEG -> GCS)
##############################
resource "google_compute_global_network_endpoint_group" "gcs_neg" {
  count = var.enable_cdn && var.origin_type == "gcs" ? 1 : 0

  name                  = "${local.name_prefix}-gcs-neg"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "gcs_endpoint" {
  count = var.enable_cdn && var.origin_type == "gcs" ? 1 : 0

  global_network_endpoint_group = google_compute_global_network_endpoint_group.gcs_neg[0].id
  fqdn                          = "${var.gcs_bucket_name}.storage.googleapis.com"
  #fqdn                           = "storage.googleapis.com"
  port                           = 80
}

###############################################
# BACKEND SERVICE for GCS origin (NEG → GCS)
###############################################
resource "google_compute_backend_service" "cdn_gcs_backend" {
  count = var.enable_cdn && var.origin_type == "gcs" ? 1 : 0

  name                    = "${local.name_prefix}-gcs-backend"
  protocol                = "HTTP"
  enable_cdn              = true
  timeout_sec             = 30
  load_balancing_scheme   = "EXTERNAL_MANAGED"   # REQUIRED FIX

  backend {
    group = google_compute_global_network_endpoint_group.gcs_neg[0].id
  }

  custom_request_headers = [
  "Host: ${var.gcs_bucket_name}.storage.googleapis.com"
]

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = var.default_ttl
    max_ttl           = var.max_ttl
    client_ttl        = var.min_ttl
    serve_while_stale = 86400

    cache_key_policy {
      include_host         = true
      include_protocol     = true
      include_query_string = var.forward_query_string
    }
  }
}

###############################################
# CUSTOM ORIGIN (NEG / MIG / INSTANCE GROUP)
###############################################
resource "google_compute_backend_service" "cdn_backend" {
  count = var.enable_cdn && var.origin_type == "custom" ? 1 : 0

  name                  = "${local.name_prefix}-backend-service"
  protocol              = var.backend_protocol
  timeout_sec           = var.backend_timeout
  enable_cdn            = true
  load_balancing_scheme = "EXTERNAL_MANAGED"    # REQUIRED FIX

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }

  dynamic "backend" {
    for_each = var.backend_group != null && var.backend_group != "" ? [var.backend_group] : []
    content {
      group = backend.value
    }
  }

  health_checks = var.health_checks

  cdn_policy {
    cache_mode  = "CACHE_ALL_STATIC"
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
    client_ttl  = var.min_ttl

    cache_key_policy {
      include_host         = true
      include_protocol     = true
      include_query_string = var.forward_query_string
    }
  }
}

#########################
# URL MAP
#########################
resource "google_compute_url_map" "cdn_url_map" {
  count = var.enable_cdn ? 1 : 0

  name = "${local.name_prefix}-url-map"

  default_service = var.origin_type == "gcs" ? google_compute_backend_service.cdn_gcs_backend[0].self_link : google_compute_backend_service.cdn_backend[0].self_link

  dynamic "host_rule" {
    for_each = var.host_rules
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.value.path_matcher
    }
  }

  dynamic "path_matcher" {
    for_each = var.path_matchers
    content {
      name            = path_matcher.value.name
      default_service = var.origin_type == "gcs" ? google_compute_backend_service.cdn_gcs_backend[0].self_link : google_compute_backend_service.cdn_backend[0].self_link

      dynamic "path_rule" {
        for_each = lookup(path_matcher.value, "path_rules", [])
        content {
          paths   = path_rule.value.paths
          service = path_rule.value.service
        }
      }
    }
  }
}

##############################################
# HTTPS PROXY (optional)
##############################################
resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  count = var.enable_cdn && var.enable_https ? 1 : 0

  name             = "${local.name_prefix}-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map[0].self_link
  ssl_certificates = var.ssl_certificates
}

##############################################
# HTTP PROXY (optional)
##############################################
resource "google_compute_target_http_proxy" "cdn_http_proxy" {
  count = var.enable_cdn && !var.enable_https ? 1 : 0

  name    = "${local.name_prefix}-http-proxy"
  url_map = google_compute_url_map.cdn_url_map[0].self_link
}

##############################################
# GLOBAL FORWARDING RULES
##############################################
resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule_https" {
  count = var.enable_cdn && var.enable_https ? 1 : 0

  name                  = "${local.name_prefix}-https-rule"
  target                = google_compute_target_https_proxy.cdn_https_proxy[0].self_link
  port_range            = "443"
  ip_address            = var.global_ip
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule_http" {
  count = var.enable_cdn && !var.enable_https ? 1 : 0

  name                  = "${local.name_prefix}-http-rule"
  target                = google_compute_target_http_proxy.cdn_http_proxy[0].self_link
  port_range            = "80"
  ip_address            = var.global_ip
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
