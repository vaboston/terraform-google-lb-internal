output "ip_address" {
  description = "The external ip address of the forwarding rule."
  value       = module.lb_internal.ip_address
}

output "id" {
  value       = module.lb_internal.id
  description = "An identifier for the resource with format"
}

output "creation_timestamp" {
  value       = module.lb_internal.creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "psc_connection_id" {
  value       = module.lb_internal.psc_connection_id
  description = "The PSC connection id of the PSC Forwarding Rule."
}

output "psc_connection_status" {
  value       = module.lb_internal.psc_connection_status
  description = "The PSC connection status of the PSC Forwarding Rule."
}

output "label_fingerprint" {
  value       = module.lb_internal.label_fingerprint
  description = "The fingerprint used for optimistic locking of this resource. "
}

output "service_name" {
  value       = module.lb_internal.service_name
  description = "The internal fully qualified service name for this Forwarding Rule. "
}

output "base_forwarding_rule" {
  value       = module.lb_internal.base_forwarding_rule
  description = "The URL for the corresponding base Forwarding Rule."
}

output "self_link" {
  value       = module.lb_internal.self_link
  description = "The URI of the created resource."
}

output "backend_service_id" {
  value       = module.lb_internal.backend_service_id
  description = "An identifier for the resource with format"
}

output "backend_service_creation_timestamp" {
  value       = module.lb_internal.creation_timestamp
  description = "Creation timestamp in RFC3339 text format."
}

output "backend_service_fingerprint" {
  value       = module.lb_internal.backend_service_fingerprint
  description = "Fingerprint of this resource. A hash of the contents stored in this object. This field is used in optimistic locking."
}

output "backend_service_self_link" {
  value       = module.lb_internal.self_link
  description = "The URI of the created resource."
}

output "health_check_ids" {
  value = [
    module.lb_internal.health_check_ids,
    module.lb_internal.health_check_ids,
    module.lb_internal.health_check_ids
  ]
  description = "An array of identifiers for the TCP, HTTP, and HTTPS health check resources."
}

output "health_check_creation_timestamp" {
  value = {
    tcp   = module.lb_internal.health_check_creation_timestamp
    http  = module.lb_internal.health_check_creation_timestamp
    https = module.lb_internal.health_check_creation_timestamp
  }
  description = "Creation timestamps for different types of health checks."
}

output "health_check_self_links" {
  value = {
    tcp   = module.lb_internal.health_check_self_links
    http  = module.lb_internal.health_check_self_links
    https = module.lb_internal.health_check_self_links
  }
  description = "A map containing the self links of TCP, HTTP, and HTTPS health checks."
}

output "health_check_types" {
  value = {
    tcp   = module.lb_internal.health_check_types
    http  = module.lb_internal.health_check_types
    https = module.lb_internal.health_check_types
  }
  description = "The type of the health check. One of HTTP, HTTPS, TCP, or SSL."
}