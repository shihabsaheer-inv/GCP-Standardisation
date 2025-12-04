locals {
  default_scripts = {
    frontend = file("${path.root}/scripts/frontend.sh")
  }
}

resource "tls_private_key" "gcp_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.gcp_key.private_key_pem
  filename = "${path.module}/gcp_key.pem"
}


# Create Compute Engine Instances only if enabled
resource "google_compute_instance" "gcp_instance" {
  count        = var.enable_compute_engine ? var.instance_count : 0
  name         = "${var.instance_name_prefix}-${var.instance_roles[count.index]}"
  machine_type = var.instance_type
  zone         = var.zone

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name

    access_config {
      nat_ip = var.associate_public_ip_address ? google_compute_address.gcp_public_ip[count.index].address : null
    }
  }

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  metadata = {
    ssh-keys       = "gcp-user:${tls_private_key.gcp_key.public_key_openssh}"
    startup-script = lookup(var.startup_scripts, var.instance_roles[count.index], "")
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = var.instance_tags

  deletion_protection = var.deletion_protection
  depends_on          = [google_compute_address.gcp_public_ip]
}

# Allocate public IPs if needed
resource "google_compute_address" "gcp_public_ip" {
  count  = var.associate_public_ip_address && var.enable_compute_engine ? var.instance_count : 0
  name   = "public-ip-${count.index + 1}"
  region = var.region
}

# Local values for instance naming
locals {
  instance_names = var.use_sequential_naming ? [
    for i in range(var.instance_count) :
    "${var.instance_name_prefix}-${format("%0${var.name_padding}d", i + 1)}"
    ] : [
    for i in range(var.instance_count) :
    "${var.instance_name_prefix}-${i}"
  ]
}

# instance group
resource "google_compute_instance_group" "instance_group" {
  name        = "${var.instance_name_prefix}-ig"
  zone        = var.zone
  project     = var.project_id

  instances = google_compute_instance.gcp_instance[*].self_link

  named_port {
    name = "http"
    port = 80
  }

  # ✅ ADD THIS - Ensures instances are created first
  depends_on = [google_compute_instance.gcp_instance]
}

