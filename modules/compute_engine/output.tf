output "instance_ids" {
  description = "List of GCP instance IDs"
  value       = google_compute_instance.gcp_instance[*].id
}

output "public_ips" {
  description = "List of public IPs"
  value       = google_compute_instance.gcp_instance[*].network_interface[0].access_config[0].nat_ip
}

output "private_ips" {
  description = "List of private IPs"
  value       = google_compute_instance.gcp_instance[*].network_interface[0].network_ip
}

output "instance_names" {
  description = "List of instance names"
  value       = [for instance in google_compute_instance.gcp_instance : instance.name]
}

output "key_pair_name" {
  description = "Name of the SSH key used"
  value       = "gcp-key"
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.gcp_key.private_key_pem
  sensitive   = true
}

output "private_key_file_path" {
  description = "Path to the private key file"
  value       = local_file.private_key_pem.filename
}

output "instance_details" {
  description = "Detailed information about all instances"
  value = [
    for i, instance in google_compute_instance.gcp_instance : {
      id         = instance.id
      name       = instance.name
      public_ip  = instance.network_interface[0].access_config[0].nat_ip
      private_ip = instance.network_interface[0].network_ip
      zone       = instance.zone
    }
  ]
}

output "instance_group_self_links" {
  value = google_compute_instance_group.instance_group[*].self_link
}
