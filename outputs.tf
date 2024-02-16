output "ip_address" {
  description = "The external ip address of the forwarding rule."
  value       = google_compute_forwarding_rule.default.ip_address
}

output "id" {
  value       = google_compute_forwarding_rule.default.id
  description = "An identifier for the resource with format"
}

output "creation_timestamp" {
  value       = google_compute_forwarding_rule.default.psc_connection_status
  description = "Creation timestamp in RFC3339 text format."
}

output "psc_connection_id" {
  value       = google_compute_forwarding_rule.default.psc_connection_id
  description = "The PSC connection id of the PSC Forwarding Rule."
}

output "psc_connection_status" {
  value       = google_compute_forwarding_rule.default.psc_connection_status
  description = "The PSC connection status of the PSC Forwarding Rule."
}

output "label_fingerprint" {
  value       = google_compute_forwarding_rule.default.label_fingerprint
  description = "The fingerprint used for optimistic locking of this resource. "
}

output "service_name" {
  value       = google_compute_forwarding_rule.default.service_name
  description = "The internal fully qualified service name for this Forwarding Rule. "
}

output "base_forwarding_rule" {
  value       = google_compute_forwarding_rule.default.base_forwarding_rule
  description = "The URL for the corresponding base Forwarding Rule."
}

output "self_link" {
  value       = google_compute_forwarding_rule.default.self_link
  description = "The URI of the created resource."
}

output "backend_service_id" {
  value       = google_compute_region_backend_service.default.id
  description = "An identifier for the resource with format"
}

output "backend_service_creation_timestamp" {
  value       = google_compute_region_backend_service.default.creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "backend_service_fingerprint" {
  value       = google_compute_region_backend_service.default.fingerprint
  description = "Fingerprint of this resource. A hash of the contents stored in this object. This field is used in optimistic locking."
}

output "backend_service_self_link" {
  value       = google_compute_region_backend_service.default.self_link
  description = "The URI of the created resource."
}

output "health_check_ids" {
  value = {
    tcp   = [for idx, check in google_compute_health_check.tcp : check.id]
    http  = [for idx, check in google_compute_health_check.http : check.id]
    https = [for idx, check in google_compute_health_check.https : check.id]
  }
  description = "An array of identifiers for the TCP, HTTP, and HTTPS health check resources."
}

output "health_check_creation_timestamp" {
  value = {
    tcp   = [for idx, check in google_compute_health_check.tcp : check.creation_timestamp]
    http  = [for idx, check in google_compute_health_check.http : check.creation_timestamp]
    https = [for idx, check in google_compute_health_check.https : check.creation_timestamp]
  }
  description = "Creation timestamps for different types of health checks."
}

output "health_check_self_links" {
  value = {
    tcp   = [for idx, check in google_compute_health_check.tcp : check.self_link]
    http  = [for idx, check in google_compute_health_check.http : check.self_link]
    https = [for idx, check in google_compute_health_check.https : check.self_link]
  }
  description = "A map containing the self links of TCP, HTTP, and HTTPS health checks."
}

output "health_check_types" {
  value = {
    tcp   = [for idx, check in google_compute_health_check.tcp : check.type]
    http  = [for idx, check in google_compute_health_check.http : check.type]
    https = [for idx, check in google_compute_health_check.https : check.type]
  }
  description = "The type of the health check. One of HTTP, HTTPS, TCP, or SSL."
}