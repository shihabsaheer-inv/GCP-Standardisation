output "log_bucket_name" {
  value = try(google_logging_project_bucket_config.log_bucket[0].name, null)
}

output "alert_policy_id" {
  value = try(google_monitoring_alert_policy.metric_alert[0].id, null)
}

output "alert_policy_name" {
  value = try(google_monitoring_alert_policy.metric_alert[0].display_name, null)
}

output "notification_channels" {
  value = google_monitoring_notification_channel.email_channel[*].name
}
