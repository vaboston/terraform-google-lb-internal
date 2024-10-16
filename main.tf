module "labels" {
  source      = "cypik/labels/google"
  version     = "1.0.1"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
}

data "google_client_config" "current" {
}

#####==============================================================================
##### A ForwardingRule resource.
#####==============================================================================
resource "google_compute_forwarding_rule" "default" {
  project               = data.google_client_config.current.project
  name                  = var.name
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  allow_global_access   = var.global_access
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.self_link
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  ports                 = var.ports
  all_ports             = var.all_ports
  service_label         = var.service_label
  labels                = var.labels
}

#####==============================================================================
##### A Region Backend Service defines a regionally-scoped group of virtual machines
##### that will serve traffic for load balancing.
#####==============================================================================
resource "google_compute_region_backend_service" "default" {
  project = data.google_client_config.current.project
  name = {
    "tcp"   = "${var.name}-with-tcp-hc",
    "http"  = "${var.name}-with-http-hc",
    "https" = "${var.name}-with-https-hc",
  }[var.health_check["type"]]
  region   = var.region
  protocol = var.ip_protocol
  network  = var.network
  # Do not try to add timeout_sec, as it is has no impact. See https://github.com/terraform-google-modules/terraform-google-lb-internal/issues/53#issuecomment-893427675
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  session_affinity                = var.session_affinity
  dynamic "backend" {
    for_each = var.backends
    content {
      group       = lookup(backend.value, "group", null)
      description = lookup(backend.value, "description", null)
      failover    = lookup(backend.value, "failover", null)
    }
  }
  health_checks = concat(google_compute_health_check.tcp[*].self_link, google_compute_health_check.http[*].self_link, google_compute_health_check.https[*].self_link)
}

#####==============================================================================
##### Health Checks determine whether instances are responsive and able to do work.
#####==============================================================================
resource "google_compute_health_check" "tcp" {
  provider = google-beta
  count    = var.health_check["type"] == "tcp" ? 1 : 0
  project  = data.google_client_config.current.project
  name     = "${var.name}-hc-tcp"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  tcp_health_check {
    port         = var.health_check["port"]
    request      = var.health_check["request"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

#####==============================================================================
##### Health Checks determine whether instances are responsive and able to do work.
#####==============================================================================
resource "google_compute_health_check" "http" {
  provider = google-beta
  count    = var.health_check["type"] == "http" ? 1 : 0
  project  = data.google_client_config.current.project
  name     = "${var.name}-hc-http"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  http_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

#####==============================================================================
##### Health Checks determine whether instances are responsive and able to do work.
#####==============================================================================
resource "google_compute_health_check" "https" {
  provider = google-beta
  count    = var.health_check["type"] == "https" ? 1 : 0
  project  = data.google_client_config.current.project
  name     = "${var.name}-hc-https"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  https_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_firewall" "default-ilb-fw" {
  count   = var.create_backend_firewall ? 1 : 0
  project = data.google_client_config.current.project == "" ? data.google_client_config.current.project : data.google_client_config.current.project
  name    = "${var.name}-ilb-fw"
  network = var.network

  allow {
    protocol = lower(var.ip_protocol)
    ports    = var.ports
  }

  source_ranges           = var.source_ip_ranges
  source_tags             = var.source_tags
  source_service_accounts = var.source_service_accounts
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts

  dynamic "log_config" {
    for_each = var.firewall_enable_logging ? [true] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
#tfsec:ignore:google-compute-no-public-ingress
resource "google_compute_firewall" "default-hc" {
  count   = var.create_health_check_firewall ? 1 : 0
  project = data.google_client_config.current.project == "" ? data.google_client_config.current.project : data.google_client_config.current.project
  name    = "${var.name}-hc"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check["port"]]
  }

  source_ranges           = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts

  dynamic "log_config" {
    for_each = var.firewall_enable_logging ? [true] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}