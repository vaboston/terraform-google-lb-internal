provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}
#
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

module "gce_ilb" {
  source       = "../../"
  region       = "asia-northeast1"
  name         = "group-ilb"
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
