resource "google_compute_network" "vpc" {
  name = "lucy-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "west4" {
  name = "lucy-west4"
  ip_cidr_range = "10.10.0.0/20"
  region = "us-west4"
  network = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_router" "nat-router" {
  name = "lucy-nat-router"
  region = "us-west4"
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name = "lucy-nat"
  router = google_compute_router.nat-router.name
  region = "us-west4"
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}