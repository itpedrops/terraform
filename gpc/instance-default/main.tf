resource "google_compute_instance_template" "default" {
  name        = "rundeck-gcp"
  description = "This template is used to create app server instances."

  tags = ["name", "rundec-gcp"]

  labels = {
    environment = "prd"
  }

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-8"
    auto_delete  = true
    boot         = true
  }

  // Use an existing disk resource
  disk {
    source      = "foo_existing_disk"
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "default"
  }

  metadata {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
