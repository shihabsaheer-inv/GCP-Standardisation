##############################################################
# Cloud Run Service
##############################################################

resource "google_cloud_run_service" "this" {
  count    = var.create ? 1 : 0
  name     = var.name
  location = var.region
  project  = var.project_id

  # 👇 Service-level metadata (belongs here)
  metadata {
    annotations = {
      "run.googleapis.com/ingress" = lookup({
        "ALLOW_ALL"         = "all",
        "INTERNAL_ONLY"     = "internal",
        "INTERNAL_AND_GCLB" = "internal-and-cloud-load-balancing",
        "NONE"              = "none"
      }, upper(var.ingress), "all")
    }

    labels = var.labels
  }

  template {
    metadata {
      annotations = merge(
        var.vpc_connector != null ? {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector
        } : {},
        var.min_instances != 0 ? {
          "autoscaling.knative.dev/minScale" = tostring(var.min_instances)
        } : {},
        var.max_instances != 0 ? {
          "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
        } : {}
      )
    }

    spec {
      service_account_name  = var.service_account_email
      container_concurrency = var.concurrency
      timeout_seconds       = tonumber(regex("[0-9]+", var.timeout))

      containers {
        image = var.image

        ports {
          container_port = var.port
        }

        resources {
          limits = {
            memory = var.memory
            cpu    = var.cpu
          }
        }

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


##############################################################
# IAM Binding - Allow Public Access (optional)
##############################################################

resource "google_cloud_run_service_iam_member" "invoker_public" {
  count    = var.create && var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_service.this[0].name

  role   = "roles/run.invoker"
  member = "allUsers"
}

