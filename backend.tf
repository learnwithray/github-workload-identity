terraform {
  backend "gcs" {
    bucket = "mansaini-007"
    prefix = "tf/state"
  }
}