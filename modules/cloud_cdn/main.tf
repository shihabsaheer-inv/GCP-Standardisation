locals {
  name_prefix = var.name != "" ? var.name : "cdn"
}

##############################
# GCS ORIGIN (backend_bucket)
##############################
resource "google_compute_backend_bucket" "cdn_bucket" {
  count       = var.enable_cdn && var.origin_type == "gcs" ? 1 : 0
  name        = "${local.name_prefix}-backend-bucket"
  bucket_name = var.gcs_bucket_name

  enable_cdn = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = var.default_ttl
    max_ttl           = var.max_ttl
    client_ttl        = var.min_ttl
    serve_while_stale = 86400
  }
}

###############################################
# CUSTOM ORIGIN (NEGs / Instance Groups / MIGs)
###############################################
resource "google_compute_backend_service" "cdn_backend" {
  count = var.enable_cdn && var.origin_type == "custom" ? 1 : 0

  name        = "${local.name_prefix}-backend-service"
  protocol    = var.backend_protocol
  timeout_sec = var.backend_timeout

  enable_cdn = true

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
# URL MAP (mandatory)
#########################
resource "google_compute_url_map" "cdn_url_map" {
  count = var.enable_cdn ? 1 : 0

  name = "${local.name_prefix}-url-map"

  default_service = var.origin_type == "gcs" ? google_compute_backend_bucket.cdn_bucket[0].self_link : google_compute_backend_service.cdn_backend[0].self_link

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
      default_service = var.origin_type == "gcs" ? google_compute_backend_bucket.cdn_bucket[0].self_link : google_compute_backend_service.cdn_backend[0].self_link
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
# GLOBAL FORWARDING RULE (optional)
##############################################
resource "google_compute_global_forwarding_rule" "cdn_forwarding_rule" {
  count = var.enable_cdn && var.enable_https ? 1 : 0

  name       = "${local.name_prefix}-https-rule"
  target     = google_compute_target_https_proxy.cdn_https_proxy[0].self_link
  port_range = "443"
  ip_address = var.global_ip
}
