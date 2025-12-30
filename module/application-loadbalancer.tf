resource "google_compute_address" "compute_address_alb" {
  name         = "${var.prefix}-cloudrun-lb-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
  network_tier = "PREMIUM"
}

resource "google_compute_region_ssl_certificate" "cloudrun_ssl_certificate" {
  name        = "${var.prefix}-ssl-certificate"
  region      = google_cloud_run_v2_service.cloudrun_bankapp.location
  certificate = file("certificate.crt")
  private_key = file("mykey.key")
}

resource "google_compute_region_network_endpoint_group" "network_endpoint_group_cloudrun" {
  name                  = "${var.prefix}-cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_v2_service.cloudrun_bankapp.location  
#  network               = google_compute_network.cloudrun_vpc.id 
  cloud_run {
    service             = google_cloud_run_v2_service.cloudrun_bankapp.name
  }
}

resource "google_compute_region_backend_service" "backend_service_cloudrun" {
  name                  = "${var.prefix}-backend-service"
  region                = google_cloud_run_v2_service.cloudrun_bankapp.location
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    capacity_scaler     = 1.0
    group               = google_compute_region_network_endpoint_group.network_endpoint_group_cloudrun.id
  }
}

resource "google_compute_region_url_map" "cloudrun_url_map" {
  name        = "${var.prefix}-url-map"
  description = "${var.prefix} Routing Rules for GCP Cloud Run"
  region                = google_cloud_run_v2_service.cloudrun_bankapp.location
  default_service = google_compute_region_backend_service.backend_service_cloudrun.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }
  
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.backend_service_cloudrun.id
  }

  test {
    service = google_compute_region_backend_service.backend_service_cloudrun.id
    host    = "www.singhritesh85.com"
    path    = "/"
  }
}

resource "google_compute_region_target_https_proxy" "cloudrun_target_https_proxy" {
  name             = "${var.prefix}-https-proxy"
  region           = google_cloud_run_v2_service.cloudrun_bankapp.location
  url_map          = google_compute_region_url_map.cloudrun_url_map.id
  ssl_certificates = [google_compute_region_ssl_certificate.cloudrun_ssl_certificate.id]
}

resource "google_compute_forwarding_rule" "cloudrun_forwarding_rule_443" {
  name                  = "${var.prefix}-forwarding-rule-443"
  region                = google_cloud_run_v2_service.cloudrun_bankapp.location
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.cloudrun_target_https_proxy.id
  ip_address            = google_compute_address.compute_address_alb.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network_tier          = "PREMIUM"
  network               = google_compute_network.cloudrun_vpc.id 
#  subnetwork            = google_compute_subnetwork.proxy_only_subnetwork.id
}

resource "google_compute_region_target_http_proxy" "cloudrun_target_http_proxy" {
  name    = "${var.prefix}-http-proxy"
  region  = google_cloud_run_v2_service.cloudrun_bankapp.location
  url_map = google_compute_region_url_map.cloudrun_url_map.id
}

resource "google_compute_forwarding_rule" "cloudrun_forwarding_rule_80" {
  name                  = "${var.prefix}-forwarding-rule-80"
  region                = google_cloud_run_v2_service.cloudrun_bankapp.location
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.cloudrun_target_http_proxy.id
  ip_address            = google_compute_address.compute_address_alb.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network_tier          = "PREMIUM"
  network               = google_compute_network.cloudrun_vpc.id
#  subnetwork            = google_compute_subnetwork.proxy_only_subnetwork.id 
}
