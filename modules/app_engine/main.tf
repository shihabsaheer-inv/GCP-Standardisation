# modules/app_engine/main.tf

#########################
# Optional creation of App Engine application
# If enable_create_app = true => terraform will create the app (only for first time)
# Otherwise set enable_use_existing_app = true and module will read the existing app.
#########################

resource "google_app_engine_application" "this" {
  count       = var.enable_create_app ? 1 : 0
  project     = var.project_id
  location_id = var.location_id
}

# Choose project reference (if created -> resource, if existing -> data)
locals {
  app_exists = var.enable_create_app ? true : var.enable_use_existing_app ? true : false
}

# STANDARD VERSION
resource "google_app_engine_standard_app_version" "standard" {
  count = var.environment_type == "standard" ? 1 : 0

  project            = var.project_id
  service            = var.service_name
  version_id         = var.version_label
  runtime            = var.runtime
  instance_class     = var.instance_class

  # Ensure provider-required block is present
  entrypoint {
    shell = var.entrypoint_shell
  }

  deployment {
    zip {
      source_url = var.source_url
    }
  }

  env_variables = {
    for s in var.settings :
    s.name => s.value
  }

  # Do NOT destroy final version (safe default)
  noop_on_destroy = true

  lifecycle {}

  depends_on = [google_app_engine_application.this]
}

# FLEXIBLE VERSION
resource "google_app_engine_flexible_app_version" "flex" {
  count = var.environment_type == "flex" ? 1 : 0

  project    = var.project_id
  service    = var.service_name
  version_id = var.version_label
  runtime    = var.runtime

  deployment {
    container {
      image = var.container_image
    }
  }

  liveness_check {
    path = var.flex_liveness_path
  }

  readiness_check {
    path = var.flex_readiness_path
  }

  # For flexible, one scaling block required: use automatic_scaling by default
  automatic_scaling {
    cpu_utilization {
      target_utilization = var.flex_cpu_target_utilization
    }

    min_total_instances = var.flex_min_total_instances
    max_total_instances = var.flex_max_total_instances
  }

  env_variables = {
    for s in var.settings :
    s.name => s.value
  }

  noop_on_destroy = true

  depends_on = [
  google_app_engine_application.this
]

}

# TRAFFIC SPLIT (routes 100% to the created version)
resource "google_app_engine_service_split_traffic" "this" {
  count          = var.enable_split_traffic ? 1 : 0
  project        = var.project_id
  service        = var.service_name
  migrate_traffic = var.migrate_traffic

  split {
    shard_by = var.split_shard_by

    allocations = (
      var.environment_type == "standard" ?
      {
        "${google_app_engine_standard_app_version.standard[0].version_id}" = 1.0
      } :
      {
        "${google_app_engine_flexible_app_version.flex[0].version_id}" = 1.0
      }
    )
  }

  # ensure versions are created before traffic set
  depends_on = [
    google_app_engine_standard_app_version.standard,
    google_app_engine_flexible_app_version.flex
  ]
}
