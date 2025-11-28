# VPC Network Outputs
output "vpc_id" {
  description = "The ID of the created VPC."
  value       = try(google_compute_network.vpc[0].id, null)
}

output "network_self_link" {
  description = "Self link of the created VPC network."
  value       = try(google_compute_network.vpc[0].self_link, null)
}

# Public Subnet Outputs
output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = try(google_compute_subnetwork.public_subnet[*].id, [])
}

output "public_subnet_self_links" {
  description = "List of public subnet self links."
  value       = try(google_compute_subnetwork.public_subnet[*].self_link, [])
}

output "public_subnet_names" {
  description = "List of public subnet names."
  value       = try(google_compute_subnetwork.public_subnet[*].name, [])
}

# Private Subnet Outputs
output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value       = try(google_compute_subnetwork.private_subnet[*].id, [])
}

output "private_subnet_self_links" {
  description = "List of private subnet self links."
  value       = try(google_compute_subnetwork.private_subnet[*].self_link, [])
}

output "private_subnet_names" {
  description = "List of private subnet names."
  value       = try(google_compute_subnetwork.private_subnet[*].name, [])
}


# GKE
output "vpc_self_link" {
  value = google_compute_network.vpc[0].self_link
}

