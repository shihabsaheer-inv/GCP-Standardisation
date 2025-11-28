resource "google_compute_firewall" "allow_ssh" {
  count   = var.enable_firewall ? 1 : 0
  name    = "${var.vpc_name}-allow-ssh"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["allow-ssh"]
}

resource "google_compute_firewall" "allow_internal" {
  count   = var.enable_firewall ? 1 : 0
  name    = "${var.vpc_name}-allow-internal"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = var.internal_source_ranges
}

resource "google_compute_firewall" "allow_http" {
  count   = var.enable_firewall ? 1 : 0
  name    = "${var.vpc_name}-allow-http"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http"]
}



