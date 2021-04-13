<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="500px">

# terraform-cloudfoundry-loki
Deploys a Grafana Loki instance to Cloud foundry

# Usages

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| cloudfoundry | >= 0.1400.0 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.1400.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [cloudfoundry_app](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/resources/app) |
| [cloudfoundry_domain](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/data-sources/domain) |
| [cloudfoundry_network_policy](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/resources/network_policy) |
| [cloudfoundry_org](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/data-sources/org) |
| [cloudfoundry_route](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/resources/route) |
| [cloudfoundry_service](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/data-sources/service) |
| [cloudfoundry_space](https://registry.terraform.io/providers/philips-labs/cloudfoundry/0.1400.0/docs/data-sources/space) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cf\_domain | The CF domain to use for Grafana | `string` | n/a | yes |
| cf\_org | The CF Org to deploy under | `string` | n/a | yes |
| cf\_space | The CF Space to deploy in | `string` | n/a | yes |
| disk | The amount of Disk space to allocate for Grafana Loki (MB) | `number` | `4096` | no |
| environment | Environment variables for Grafana Loki | `map(any)` | `{}` | no |
| loki\_image | Tempo Docker image to use | `string` | `"philipslabs/cf-loki:latest"` | no |
| memory | The amount of RAM to allocate for Loki (MB) | `number` | `1024` | no |
| name\_postfix | The postfix string to append to the hostname, prevents namespace clashes | `string` | `""` | no |
| network\_policies | The container-to-container network policies to create with Grafana as the source app | <pre>list(object({<br>    destination_app = string<br>    protocol        = string<br>    port            = string<br>  }))</pre> | `[]` | no |
| s3\_broker\_settings | The S3 service broker to use | <pre>object({<br>    service_broker = string<br>    service_plan   = string<br>  })</pre> | <pre>{<br>  "service_broker": "hsdp-s3",<br>  "service_plan": "s3_bucket"<br>}</pre> | no |
| s3\_credentials | n/a | <pre>object({<br>    s3_access_key        = string<br>    s3_secret_access_key = string<br>    s3_endpoint          = string<br>    s3_bucket            = string<br>  })</pre> | <pre>{<br>  "s3_access_key": "",<br>  "s3_bucket": "",<br>  "s3_endpoint": "",<br>  "s3_secret_access_key": ""<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| loki\_endpoint | The endpoint where Loki is reachable on |
| loki\_id | The Loki apps' id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel

# License
[License](./LICENSE.md) is MIT
