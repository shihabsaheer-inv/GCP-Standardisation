# Create the VPC only if enabled
resource "google_compute_network" "vpc" {
  count                   = var.enable_vpc ? 1 : 0
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Create Public Subnets only if VPC is enabled
resource "google_compute_subnetwork" "public_subnet" {
  count                    = var.enable_vpc ? length(var.public_subnet_cidrs) : 0
  name                     = "public-subnet-${count.index + 1}"
  region                   = var.region
  network                  = google_compute_network.vpc[0].id
  ip_cidr_range            = element(var.public_subnet_cidrs, count.index)
  private_ip_google_access = false
}

# Create Private Subnets only if VPC is enabled
resource "google_compute_subnetwork" "private_subnet" {
  count                    = var.enable_vpc ? length(var.private_subnet_cidrs) : 0
  name                     = "private-subnet-${count.index + 1}"
  region                   = var.region
  network                  = google_compute_network.vpc[0].id
  ip_cidr_range            = element(var.private_subnet_cidrs, count.index)

    # Add these dynamic blocks for GKE secondary ranges
  dynamic "secondary_ip_range" {
    for_each = var.enable_gke_secondary_ranges && count.index == 0 ? [1] : []
    content {
      range_name    = var.gke_pods_range_name
      ip_cidr_range = var.gke_pods_cidr_range
    }
  }

  dynamic "secondary_ip_range" {
    for_each = var.enable_gke_secondary_ranges && count.index == 0 ? [1] : []
    content {
      range_name    = var.gke_services_range_name
      ip_cidr_range = var.gke_services_cidr_range
    }
  }

  private_ip_google_access = true
}

# NAT router (optional)
resource "google_compute_router" "router" {
  count   = var.enable_vpc ? 1 : 0
  name    = "nat-router"
  network = google_compute_network.vpc[0].id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count  = var.enable_vpc ? 1 : 0
  name   = "nat-gateway"
  router = google_compute_router.router[0].name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# ─────────────────────────────
# 🔌 Private Service Access for Cloud SQL
# ─────────────────────────────

# 1️⃣ Enable Service Networking API
resource "google_project_service" "service_networking" {
  project = var.project_id
  service = "servicenetworking.googleapis.com"
}

# 2️⃣ Reserve an internal IP range for Google-managed services
resource "google_compute_global_address" "private_service_range" {
  name          = "${var.vpc_name}-private-service-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc[0].self_link
  project       = var.project_id
  depends_on    = [google_project_service.service_networking]
}

# 3️⃣ Create the private VPC connection for Google-managed services
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc[0].self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_range.name]

  depends_on = [
    google_project_service.service_networking,
    google_compute_global_address.private_service_range
  ]
}
