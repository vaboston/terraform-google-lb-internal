provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

locals {
  named_ports = [{
    name = "http"
    port = 80
  }]
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
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

#####==============================================================================
##### instance_template module call.
#####==============================================================================
module "instance_template" {
  source               = "cypik/template-instance/google"
  version              = "1.0.1"
  name                 = "template"
  environment          = "test"
  region               = "asia-northeast1"
  source_image         = "ubuntu-2204-jammy-v20230908"
  source_image_family  = "ubuntu-2204-lts"
  source_image_project = "ubuntu-os-cloud"
  disk_size_gb         = "20"
  subnetwork           = module.subnet.subnet_id
  instance_template    = true
  service_account      = null
  ## public IP if enable_public_ip is true
  enable_public_ip = true
  metadata = {
    ssh-keys = <<EOF
      dev:ssh-rsa AAAAB3NzaC1yc2EAA/3mwt2y+PDQMU= suresh@suresh
    EOF
  }
}

#####==============================================================================
##### instance_group module call.
#####==============================================================================
module "instance_group" {
  source              = "cypik/instance-group/google"
  version             = "1.0.1"
  region              = "asia-northeast1"
  hostname            = "test"
  autoscaling_enabled = true
  instance_template   = module.instance_template.self_link_unique
  min_replicas        = 2
  max_replicas        = 2
  autoscaling_cpu = [{
    target            = 0.5
    predictive_method = ""
  }]

  target_pools = [
    module.load_balancer.target_pool
  ]
  named_ports = [{
    name = "http"
    port = 80
  }]
}

#####==============================================================================
##### load_balancer module call.
#####==============================================================================
module "load_balancer" {
  source                  = "cypik/lb/google"
  version                 = "1.0.1"
  name                    = "test"
  environment             = "load-balancer"
  region                  = "asia-northeast1"
  port_range              = 80
  network                 = module.vpc.vpc_id
  health_check            = local.health_check
  target_service_accounts = null
  target_tags             = ["allow-group1"]
  service_port            = local.named_ports[0].port
}

#####==============================================================================
##### lb-internal-external module call.
#####==============================================================================
module "lb_internal_external" {
  source       = "../../"
  region       = "asia-northeast1"
  name         = "lb-internal-external"
  environment  = "test"
  network      = module.vpc.self_link
  subnetwork   = module.subnet.subnet_self_link
  ports        = [local.named_ports[0].port]
  source_tags  = ["allow-group1"]
  target_tags  = ["allow-group2"]
  health_check = local.health_check

  backends = [
    {
      group       = module.instance_group.instance_group
      description = ""
      failover    = false
    }
  ]
}