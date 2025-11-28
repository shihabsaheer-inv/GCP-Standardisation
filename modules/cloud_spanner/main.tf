terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

# ───────────────────────────────────────────────
# Cloud Spanner Instance
# ───────────────────────────────────────────────

resource "google_spanner_instance" "this" {
  project      = var.project_id
  name         = var.instance_id
  config       = var.instance_config
  display_name = var.display_name

  num_nodes        = var.num_nodes
  processing_units = var.processing_units

  labels = var.labels

  force_destroy = var.force_destroy
  
  lifecycle {
    precondition {
      condition     = var.num_nodes != null || var.processing_units != null
      error_message = "You must set either spanner_num_nodes or spanner_processing_units."
    }
  }
}

# ───────────────────────────────────────────────
# Cloud Spanner Database
# ───────────────────────────────────────────────

resource "google_spanner_database" "this" {
  project  = var.project_id
  instance = google_spanner_instance.this.name
  name     = var.database_name

  deletion_protection    = var.deletion_protection
  enable_drop_protection = var.enable_drop_protection

  ddl = length(var.database_ddl) > 0 ? var.database_ddl : null
}

# ───────────────────────────────────────────────
# IAM — Instance level
# ───────────────────────────────────────────────

resource "google_spanner_instance_iam_binding" "instance_bindings" {
  for_each = { for b in var.instance_iam_bindings : b.role => b }

  project  = var.project_id
  instance = google_spanner_instance.this.name
  role     = each.value.role
  members  = each.value.members
}

# ───────────────────────────────────────────────
# IAM — Database level
# ───────────────────────────────────────────────

resource "google_spanner_database_iam_binding" "database_bindings" {
  for_each = { for b in var.database_iam_bindings : b.role => b }

  project  = var.project_id
  instance = google_spanner_instance.this.name
  database = google_spanner_database.this.name
  role     = each.value.role
  members  = each.value.members
}
