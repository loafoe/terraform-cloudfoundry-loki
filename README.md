# terraform-cloudfoundry-loki
Deploys a Grafana Loki instance to Cloud foundry

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel

# License
[License](./LICENSE.md) is MIT

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_cloudfoundry"></a> [cloudfoundry](#requirement\_cloudfoundry) | >= 0.14.2 |
| <a name="requirement_htpasswd"></a> [htpasswd](#requirement\_htpasswd) | >= 1.0.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudfoundry"></a> [cloudfoundry](#provider\_cloudfoundry) | 0.15.5 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logdrain"></a> [logdrain](#module\_logdrain) | ./modules/logdrain | n/a |
| <a name="module_proxy"></a> [proxy](#module\_proxy) | ./modules/proxy | n/a |

## Resources

| Name | Type |
|------|------|
| [cloudfoundry_app.loki](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_network_policy.loki](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_route.loki_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_service_instance.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_instance) | resource |
| [cloudfoundry_service_key.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_key) | resource |
| [random_id.id](https://registry.terraform.io/providers/random/latest/docs/resources/id) | resource |
| [random_password.token](https://registry.terraform.io/providers/random/latest/docs/resources/password) | resource |
| [cloudfoundry_domain.domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_domain.internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_service.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_caddy_image"></a> [caddy\_image](#input\_caddy\_image) | Caddy server image to use | `string` | `"library/caddy:2.4.5"` | no |
| <a name="input_cf_domain"></a> [cf\_domain](#input\_cf\_domain) | The CF domain name to use | `string` | n/a | yes |
| <a name="input_cf_space_id"></a> [cf\_space\_id](#input\_cf\_space\_id) | The CF Space to deploy in | `string` | n/a | yes |
| <a name="input_disk"></a> [disk](#input\_disk) | The amount of Disk space to allocate for Grafana Loki (MB) | `number` | `4096` | no |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | Docker registry password | `string` | `""` | no |
| <a name="input_docker_username"></a> [docker\_username](#input\_docker\_username) | Docker registry username | `string` | `""` | no |
| <a name="input_enable_cf_logdrain"></a> [enable\_cf\_logdrain](#input\_enable\_cf\_logdrain) | Enables creation of a Cloud foundry logdrain service | `bool` | `false` | no |
| <a name="input_enable_public_proxy"></a> [enable\_public\_proxy](#input\_enable\_public\_proxy) | Enables an authenticated public proxy endpoint | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for Grafana Loki | `map(any)` | `{}` | no |
| <a name="input_loki_cf_logdrain_image"></a> [loki\_cf\_logdrain\_image](#input\_loki\_cf\_logdrain\_image) | loki-cf-logdrain Docker image to use | `string` | `"loafoe/loki-cf-logdrain:v0.1.0"` | no |
| <a name="input_loki_image"></a> [loki\_image](#input\_loki\_image) | Loki Docker image to use | `string` | `"grafana/loki:2.3.0"` | no |
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
| <a name="output_loki_app_id"></a> [loki\_app\_id](#output\_loki\_app\_id) | The Loki app id |
| <a name="output_loki_endpoint"></a> [loki\_endpoint](#output\_loki\_endpoint) | The endpoint where Loki is reachable on |
| <a name="output_loki_proxy_endpoint"></a> [loki\_proxy\_endpoint](#output\_loki\_proxy\_endpoint) | The Loki proxy endpoint |
| <a name="output_loki_proxy_password"></a> [loki\_proxy\_password](#output\_loki\_proxy\_password) | The Loki proxy password. Username is always 'loki' |
| <a name="output_loki_proxy_username"></a> [loki\_proxy\_username](#output\_loki\_proxy\_username) | The Loki proxy password. Username is always 'loki' |
<!-- END_TF_DOCS -->
