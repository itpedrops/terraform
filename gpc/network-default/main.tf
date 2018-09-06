  resource "google_compute_network" "vpc-default" {
    name                    = "vpc-default"
    auto_create_subnetworks = false
  }

  resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
    name          = "subnet"
    ip_cidr_range = "172.0.0.0/16"
    region        = "us-central1"
    network       = "${google_compute_network.vpc-default.self_link}"
    secondary_ip_range {
      range_name    = "subnet-1"
      ip_cidr_range = "172.0.16.0/20"
    }
    secondary_ip_range {
      range_name    = "subnet-2"
      ip_cidr_range = "172.0.32.0/20"
    }
    secondary_ip_range {
      range_name    = "subnet-3"
      ip_cidr_range = "172.1.0.0/20"
    }
    secondary_ip_range {
      range_name    = "subnet-4"
      ip_cidr_range = "172.1.16.0/20"
    }
  }
