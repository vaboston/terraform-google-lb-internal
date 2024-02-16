# Terraform-google-lb-internal
# Terraform Google Cloud lb-Internal Module
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create lb-Internal.
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
## Examples

# Example: internal
```hcl
module "test_lb" {
  source       = "cypik/lb-internal/google"
  version      = "1.0.0"
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
```
# Example: simple
```hcl
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

module "gce-ilb" {
  source       = "cypik/lb-internal/google"
  version      = "1.0.0"
  name         = "group-ilb"
  environment  = "test"
  region       = "asia-northeast1"
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
```
You can customize the input variables according to your specific requirements.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-google-lb-internal/tree/master/examples) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-google-lb-internal/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.50, < 5.11.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.26, < 5.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.50, < 5.11.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.26, < 5.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/google | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_health_check.http](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_health_check) | resource |
| [google-beta_google_compute_health_check.https](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_health_check) | resource |
| [google-beta_google_compute_health_check.tcp](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_health_check) | resource |
| [google_compute_firewall.default-hc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.default-ilb-fw](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_forwarding_rule.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_region_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_all_ports"></a> [all\_ports](#input\_all\_ports) | Boolean for all\_ports setting on forwarding rule. | `bool` | `null` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | List of backends, should be a map of key-value pairs for each backend, must have the 'group' key. | `list(any)` | n/a | yes |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | Time for which instance will be drained | `number` | `null` | no |
| <a name="input_create_backend_firewall"></a> [create\_backend\_firewall](#input\_create\_backend\_firewall) | Controls if firewall rules for the backends will be created or not. Health-check firewall rules are controlled separately. | `bool` | `true` | no |
| <a name="input_create_health_check_firewall"></a> [create\_health\_check\_firewall](#input\_create\_health\_check\_firewall) | Controls if firewall rules for the health check will be created or not. If this rule is not present backend healthcheck will fail. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall_enable_logging"></a> [firewall\_enable\_logging](#input\_firewall\_enable\_logging) | Controls if firewall rules that are created are to have logging configured. This will be ignored for firewall rules that are not created. | `bool` | `false` | no |
| <a name="input_global_access"></a> [global\_access](#input\_global\_access) | Allow all regions on the same VPC network access. | `bool` | `false` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check to determine whether instances are responsive and able to do work | <pre>object({<br>    type                = string<br>    check_interval_sec  = number<br>    healthy_threshold   = number<br>    timeout_sec         = number<br>    unhealthy_threshold = number<br>    response            = string<br>    proxy_header        = string<br>    port                = number<br>    port_name           = string<br>    request             = string<br>    request_path        = string<br>    host                = string<br>    enable_log          = bool<br>  })</pre> | n/a | yes |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | IP address of the internal load balancer, if empty one will be assigned. Default is empty. | `string` | `null` | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | The IP protocol for the backend and frontend forwarding rule. TCP or UDP. | `string` | `"TCP"` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to attach to resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'cypik'. | `string` | `"cypik"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `""` | no |
| <a name="input_network"></a> [network](#input\_network) | Name of the network to create resources in. | `string` | `""` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | List of ports range to forward to backend services. Max is 5. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for cloud resources. | `string` | `""` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-google-lb-internal"` | no |
| <a name="input_service_label"></a> [service\_label](#input\_service\_label) | Service label is used to create internal DNS name | `string` | `null` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | The session affinity for the backends example: NONE, CLIENT\_IP. Default is `NONE`. | `string` | `"NONE"` | no |
| <a name="input_source_ip_ranges"></a> [source\_ip\_ranges](#input\_source\_ip\_ranges) | List of source ip ranges for traffic between the internal load balancer. | `list(string)` | `null` | no |
| <a name="input_source_service_accounts"></a> [source\_service\_accounts](#input\_source\_service\_accounts) | List of source service accounts for traffic between the internal load balancer. | `list(string)` | `null` | no |
| <a name="input_source_tags"></a> [source\_tags](#input\_source\_tags) | List of source tags for traffic between the internal load balancer. | `list(string)` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Name of the subnetwork to create resources in. | `string` | `""` | no |
| <a name="input_target_service_accounts"></a> [target\_service\_accounts](#input\_target\_service\_accounts) | List of target service accounts for traffic between the internal load balancer. | `list(string)` | `null` | no |
| <a name="input_target_tags"></a> [target\_tags](#input\_target\_tags) | List of target tags for traffic between the internal load balancer. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_service_creation_timestamp"></a> [backend\_service\_creation\_timestamp](#output\_backend\_service\_creation\_timestamp) | Creation timestamp in RFC3339 text format. |
| <a name="output_backend_service_fingerprint"></a> [backend\_service\_fingerprint](#output\_backend\_service\_fingerprint) | Fingerprint of this resource. A hash of the contents stored in this object. This field is used in optimistic locking. |
| <a name="output_backend_service_id"></a> [backend\_service\_id](#output\_backend\_service\_id) | An identifier for the resource with format |
| <a name="output_backend_service_self_link"></a> [backend\_service\_self\_link](#output\_backend\_service\_self\_link) | The URI of the created resource. |
| <a name="output_base_forwarding_rule"></a> [base\_forwarding\_rule](#output\_base\_forwarding\_rule) | The URL for the corresponding base Forwarding Rule. |
| <a name="output_creation_timestamp"></a> [creation\_timestamp](#output\_creation\_timestamp) | Creation timestamp in RFC3339 text format. |
| <a name="output_health_check_creation_timestamp"></a> [health\_check\_creation\_timestamp](#output\_health\_check\_creation\_timestamp) | Creation timestamps for different types of health checks. |
| <a name="output_health_check_ids"></a> [health\_check\_ids](#output\_health\_check\_ids) | An array of identifiers for the TCP, HTTP, and HTTPS health check resources. |
| <a name="output_health_check_self_links"></a> [health\_check\_self\_links](#output\_health\_check\_self\_links) | A map containing the self links of TCP, HTTP, and HTTPS health checks. |
| <a name="output_health_check_types"></a> [health\_check\_types](#output\_health\_check\_types) | The type of the health check. One of HTTP, HTTPS, TCP, or SSL. |
| <a name="output_id"></a> [id](#output\_id) | An identifier for the resource with format |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The external ip address of the forwarding rule. |
| <a name="output_label_fingerprint"></a> [label\_fingerprint](#output\_label\_fingerprint) | The fingerprint used for optimistic locking of this resource. |
| <a name="output_psc_connection_id"></a> [psc\_connection\_id](#output\_psc\_connection\_id) | The PSC connection id of the PSC Forwarding Rule. |
| <a name="output_psc_connection_status"></a> [psc\_connection\_status](#output\_psc\_connection\_status) | The PSC connection status of the PSC Forwarding Rule. |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The internal fully qualified service name for this Forwarding Rule. |
<!-- END_TF_DOCS -->