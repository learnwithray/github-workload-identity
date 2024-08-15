resource "google_storage_bucket" "my-bucket" {
  name                     = "mansaini-008"
  location                 = "us-central1"
  project                  = "burner-mansaini"
  force_destroy            = true
  public_access_prevention = "enforced"
}