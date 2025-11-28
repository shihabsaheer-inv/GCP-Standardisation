resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.region
  force_destroy = var.force_destroy
  labels        = var.labels

  versioning {
    enabled = var.enable_versioning
  }

  # Enable static website hosting ONLY when requested
  dynamic "website" {
    for_each = var.enable_static_website ? [1] : []
    content {
      main_page_suffix = var.index_document
      not_found_page   = var.error_document
    }
  }

  uniform_bucket_level_access = true
}

# Upload index.html (only when static website is enabled)
resource "google_storage_bucket_object" "index" {
  count  = var.enable_static_website ? 1 : 0
  name   = var.index_document
  source = "${path.module}/static/${var.index_document}"
  bucket = google_storage_bucket.this.name
  content_type = "text/html"
}

# Upload 404.html (only when static website is enabled)
resource "google_storage_bucket_object" "error" {
  count  = var.enable_static_website ? 1 : 0
  name   = var.error_document
  source = "${path.module}/static/${var.error_document}"
  bucket = google_storage_bucket.this.name
  content_type = "text/html"
}

# Public access IAM binding (optional)
resource "google_storage_bucket_iam_member" "public_access" {
  count  = var.enable_public_access ? length(var.public_access_members) : 0
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectViewer"
  member = var.public_access_members[count.index]
}
