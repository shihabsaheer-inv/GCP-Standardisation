output "ssh_firewall_id" {
  description = "ID of the SSH firewall rule"
  value       = try(google_compute_firewall.allow_ssh[0].id, null)
}

output "internal_firewall_id" {
  description = "ID of the internal firewall rule"
  value       = try(google_compute_firewall.allow_internal[0].id, null)
}


