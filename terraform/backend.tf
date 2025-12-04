terraform {
  backend "gcs" {
    bucket = "terraform-project-test124-tfbucket"
    prefix = "terraform/state"
  }
}
