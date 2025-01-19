resource "google_compute_url_map" "endpoint_lb" {
  name = "vertex-endpoint-lb"
  default_service = google_compute_backend_service.endpoint_service.id
  host_rule {
    hosts = ["*.endpoints.api-for-warp-drive.cloud.goog"]
    path_matcher = "vertex-paths"
  }
  path_matcher {
    name = "vertex-paths"
    default_service = google_compute_backend_service.endpoint_service.id
  }
}

resource "google_compute_backend_service" "endpoint_service" {
  name = "vertex-endpoints"
  protocol = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  locality_lb_policy = "ROUND_ROBIN"
  backend {
    group = google_compute_instance_group.us_central1.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
  backend {
    group = google_compute_instance_group.us_west1.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
  backend {
    group = google_compute_instance_group.us_west4.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
  health_checks = [google_compute_health_check.endpoint_health.id]
  enable_cdn = true
}