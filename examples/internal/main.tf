provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#resource "random_string" "suffix" {
#  length  = 8
#  upper   = false
#  lower   = true
#  numeric = true
#  special = false
#}

locals {
  #  random_suffix = random_string.suffix.result
  resource_name = "lb-minimal"
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 8081
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
    enable_log          = false
  }
}

#####==============================================================================
##### vpc module call.
#####==============================================================================
module "vpc" {
  source                                    = "cypik/vpc/google"
  version                                   = "1.0.1"
  name                                      = "app"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

#####==============================================================================
##### subnet module call.
#####==============================================================================
module "subnet" {
  source        = "cypik/subnet/google"
  version       = "1.0.1"
  name          = "app"
  environment   = "test"
  subnet_names  = ["subnet-a"]
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.1.0/24"]
}
#####==============================================================================
##### firewall module call.
#####==============================================================================
module "firewall" {
  source        = "cypik/firewall/google"
  version       = "1.0.1"
  name          = "app"
  environment   = "test"
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

module "test_lb" {
  source       = "../../"
  network      = module.vpc.vpc_id
  subnetwork   = module.subnet.subnet_id
  region       = "asia-northeast1"
  name         = local.resource_name
  ports        = ["8080"]
  source_tags  = ["source-tag-foo"]
  target_tags  = ["target-tag-bar"]
  backends     = []
  health_check = local.health_check
}