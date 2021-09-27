<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# terraform-cloudfoundry-loki
Deploys a Grafana Loki instance to Cloud foundry

# Usages

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_cloudfoundry"></a> [cloudfoundry](#requirement\_cloudfoundry) | >= 0.14.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudfoundry"></a> [cloudfoundry](#provider\_cloudfoundry) | >= 0.14.2 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudfoundry_app.loki](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.lokiproxy](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_network_policy.loki](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_network_policy.lokiproxy](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_route.loki_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.lokiproxy](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_service_instance.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_instance) | resource |
| [cloudfoundry_service_key.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_key) | resource |
| [cloudfoundry_user_provided_service.logdrain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/user_provided_service) | resource |
| [random_id.id](https://registry.terraform.io/providers/random/latest/docs/resources/id) | resource |
| [random_password.token](https://registry.terraform.io/providers/random/latest/docs/resources/password) | resource |
| [cloudfoundry_domain.domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_domain.internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_service.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cf_domain"></a> [cf\_domain](#input\_cf\_domain) | The CF domain name to use | `string` | n/a | yes |
| <a name="input_cf_space_id"></a> [cf\_space\_id](#input\_cf\_space\_id) | The CF Space to deploy in | `string` | n/a | yes |
| <a name="input_disk"></a> [disk](#input\_disk) | The amount of Disk space to allocate for Grafana Loki (MB) | `number` | `4096` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for Grafana Loki | `map(any)` | `{}` | no |
| <a name="input_loki_image"></a> [loki\_image](#input\_loki\_image) | Loki Docker image to use | `string` | `"grafana/loki:2.3.0"` | no |
| <a name="input_lokiproxy_image"></a> [lokiproxy\_image](#input\_lokiproxy\_image) | lokiproxy Docker image to use | `string` | `"loafoe/lokiproxy:v0.0.3"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of RAM to allocate for Loki (MB) | `number` | `1024` | no |
| <a name="input_name_postfix"></a> [name\_postfix](#input\_name\_postfix) | The postfix string to append to the hostname, prevents namespace clashes | `string` | `""` | no |
| <a name="input_network_policies"></a> [network\_policies](#input\_network\_policies) | The container-to-container network policies to create with Grafana as the source app | <pre>list(object({<br>    destination_app = string<br>    protocol        = string<br>    port            = string<br>  }))</pre> | `[]` | no |
| <a name="input_s3_broker_settings"></a> [s3\_broker\_settings](#input\_s3\_broker\_settings) | The S3 service broker to use | <pre>object({<br>    service_broker = string<br>    service_plan   = string<br>  })</pre> | <pre>{<br>  "service_broker": "hsdp-s3",<br>  "service_plan": "s3_bucket"<br>}</pre> | no |
| <a name="input_s3_credentials"></a> [s3\_credentials](#input\_s3\_credentials) | n/a | <pre>object({<br>    access_key = string<br>    secret_key = string<br>    endpoint   = string<br>    bucket     = string<br>  })</pre> | <pre>{<br>  "access_key": "",<br>  "bucket": "",<br>  "endpoint": "",<br>  "secret_key": ""<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logdrain_endpoint"></a> [logdrain\_endpoint](#output\_logdrain\_endpoint) | The logproxy logdrain endpoint |
| <a name="output_logdrain_service_id"></a> [logdrain\_service\_id](#output\_logdrain\_service\_id) | The uuid of the logdrain service. You can bind this to your app to enable logdraining |
| <a name="output_loki_endpoint"></a> [loki\_endpoint](#output\_loki\_endpoint) | The endpoint where Loki is reachable on |
| <a name="output_loki_id"></a> [loki\_id](#output\_loki\_id) | The Loki apps' id |

<!--- END_TF_DOCS --->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel

# License
[License](./LICENSE.md) is MIT
