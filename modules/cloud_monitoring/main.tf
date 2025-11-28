###############################
# Optional Log Bucket
###############################
resource "google_logging_project_bucket_config" "log_bucket" {
  count   = var.enable_log_bucket ? 1 : 0
  project = var.project_id

  bucket_id                 = var.log_bucket_id
  location                  = var.location
  retention_days            = var.log_retention_days
  enable_analytics          = var.enable_analytics
}

###############################
# Notification Channel (Email)
###############################
resource "google_monitoring_notification_channel" "email_channel" {
  count = length(var.notification_emails)

  display_name = "Email Notification ${count.index}"
  type         = "email"

  labels = {
    email_address = var.notification_emails[count.index]
  }

  project = var.project_id
}

###############################
# Alert Policy
###############################
resource "google_monitoring_alert_policy" "metric_alert" {
  count = var.enable_alert ? 1 : 0

  project      = var.project_id
  display_name = var.alert_name

  combiner = "OR"

  notification_channels = google_monitoring_notification_channel.email_channel[*].name

  conditions {
    display_name = var.metric_display_name

    condition_threshold {
      comparison       = var.comparison
      threshold_value  = var.threshold_value
      duration         = "${var.duration}s"
      filter           = var.metric_filter

      aggregations {
        alignment_period     = "${var.alignment_period}s"
        per_series_aligner   = var.per_series_aligner
      }
    }
  }
}
