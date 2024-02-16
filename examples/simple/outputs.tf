output "ip_address" {
  description = "The external ip address of the forwarding rule."
  value       = module.gce_ilb.ip_address
}

output "id" {
  value       = module.gce_ilb.id
  description = "An identifier for the resource with format"
}

output "creation_timestamp" {
  value       = module.gce_ilb.creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "psc_connection_id" {
  value       = module.gce_ilb.psc_connection_id
  description = "The PSC connection id of the PSC Forwarding Rule."
}

output "psc_connection_status" {
  value       = module.gce_ilb.psc_connection_status
  description = "The PSC connection status of the PSC Forwarding Rule."
}

output "label_fingerprint" {
  value       = module.gce_ilb.label_fingerprint
  description = "The fingerprint used for optimistic locking of this resource. "
}

output "service_name" {
  value       = module.gce_ilb.service_name
  description = "The internal fully qualified service name for this Forwarding Rule. "
}

output "base_forwarding_rule" {
  value       = module.gce_ilb.base_forwarding_rule
  description = "The URL for the corresponding base Forwarding Rule."
}

output "self_link" {
  value       = module.gce_ilb.self_link
  description = "The URI of the created resource."
}

output "backend_service_id" {
  value       = module.gce_ilb.backend_service_id
  description = "An identifier for the resource with format"
}

output "backend_service_creation_timestamp" {
  value       = module.gce_ilb.creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "backend_service_fingerprint" {
  value       = module.gce_ilb.backend_service_fingerprint
  description = "Fingerprint of this resource. A hash of the contents stored in this object. This field is used in optimistic locking."
}

output "backend_service_self_link" {
  value       = module.gce_ilb.self_link
  description = "The URI of the created resource."
}

output "health_check_ids" {
  value = [
    module.gce_ilb.health_check_ids,
    module.gce_ilb.health_check_ids,
    module.gce_ilb.health_check_ids
  ]
  description = "An array of identifiers for the TCP, HTTP, and HTTPS health check resources."
}


output "health_check_creation_timestamp" {
  value = {
    tcp   = module.gce_ilb.health_check_creation_timestamp
    http  = module.gce_ilb.health_check_creation_timestamp
    https = module.gce_ilb.health_check_creation_timestamp
  }
  description = "Creation timestamps for different types of health checks."
}

output "health_check_self_links" {
  value = {
    tcp   = module.gce_ilb.health_check_self_links
    http  = module.gce_ilb.health_check_self_links
    https = module.gce_ilb.health_check_self_links
  }
  description = "A map containing the self links of TCP, HTTP, and HTTPS health checks."
}

output "health_check_types" {
  value = {
    tcp   = module.gce_ilb.health_check_types
    http  = module.gce_ilb.health_check_types
    https = module.gce_ilb.health_check_types
  }
  description = "The type of the health check. One of HTTP, HTTPS, TCP, or SSL."
}