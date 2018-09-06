provider "google" {
  credentials = "${file("~/XXX.json")}"
  project     = "my-project"
  region      = "us-central1"
}
