provider "google" {
  credentials = "${file("~/xxxxxjson")}"
  project     = "my-project"
  region      = "us-central1"
}
