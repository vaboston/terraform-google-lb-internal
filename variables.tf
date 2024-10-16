variable "name" {
  type        = string
  default     = ""
  description = "Name of the resource. Provided by the client when the resource is created. "
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] ."
}

variable "managedby" {
  type        = string
  default     = "cypik"
  description = "ManagedBy, eg 'cypik'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/cypik/terraform-google-lb-internal"
  description = "Terraform current module repo"
}

variable "region" {
  description = "Region for cloud resources."
  type        = string
  default     = ""
}

variable "global_access" {
  description = "Allow all regions on the same VPC network access."
  type        = bool
  default     = false
}

variable "network" {
  description = "Name of the network to create resources in."
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  type        = string
  default     = ""
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."
  type        = list(any)
}

variable "session_affinity" {
  description = "The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`."
  type        = string
  default     = "NONE"
}

variable "ports" {
  description = "List of ports range to forward to backend services. Max is 5."
  type        = list(string)
}

variable "all_ports" {
  description = "Boolean for all_ports setting on forwarding rule."
  type        = bool
  default     = null
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    port_name           = string
    request             = string
    request_path        = string
    host                = string
    enable_log          = bool
  })
}

variable "source_tags" {
  description = "List of source tags for traffic between the internal load balancer."
  type        = list(string)
}

variable "target_tags" {
  description = "List of target tags for traffic between the internal load balancer."
  type        = list(string)
}

variable "source_ip_ranges" {
  description = "List of source ip ranges for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "source_service_accounts" {
  description = "List of source service accounts for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "target_service_accounts" {
  description = "List of target service accounts for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "ip_address" {
  description = "IP address of the internal load balancer, if empty one will be assigned. Default is empty."
  type        = string
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "service_label" {
  description = "Service label is used to create internal DNS name"
  default     = null
  type        = string
}

variable "connection_draining_timeout_sec" {
  description = "Time for which instance will be drained"
  default     = null
  type        = number
}

variable "create_backend_firewall" {
  description = "Controls if firewall rules for the backends will be created or not. Health-check firewall rules are controlled separately."
  default     = true
  type        = bool
}

variable "create_health_check_firewall" {
  description = "Controls if firewall rules for the health check will be created or not. If this rule is not present backend healthcheck will fail."
  default     = true
  type        = bool
}

variable "firewall_enable_logging" {
  description = "Controls if firewall rules that are created are to have logging configured. This will be ignored for firewall rules that are not created."
  default     = false
  type        = bool
}

variable "labels" {
  description = "The labels to attach to resources created by this module."
  default     = {}
  type        = map(string)
}