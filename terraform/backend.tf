terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket-ss"
    prefix = "terraform/state"
  }
}
