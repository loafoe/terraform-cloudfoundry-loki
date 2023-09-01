locals {
  postfix = var.name_postfix != "" ? var.name_postfix : random_id.id.hex
}

resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "token" {
  length  = 32
  special = false
}

data "cloudfoundry_service" "s3" {
  name = var.s3_broker_settings.service_broker
}

data "cloudfoundry_domain" "internal" {
  name = "apps.internal"
}

data "cloudfoundry_domain" "domain" {
  name = var.cf_domain
}

module "proxy" {
  count  = var.enable_public_proxy ? 1 : 0
  source = "./modules/proxy"


  loki_app_id            = cloudfoundry_app.loki.id
  loki_internal_endpoint = cloudfoundry_route.loki_internal.endpoint
  name_postfix           = local.postfix
  cf_domain              = var.cf_domain
  cf_space_id            = var.cf_space_id
}

module "logdrain" {
  count  = var.enable_cf_logdrain ? 1 : 0
  source = "./modules/logdrain"

  loki_app_id            = cloudfoundry_app.loki.id
  loki_internal_endpoint = cloudfoundry_route.loki_internal.endpoint
  name_postfix           = local.postfix
  cf_domain              = var.cf_domain
  cf_space_id            = var.cf_space_id
  loki_cf_logdrain_image = var.loki_cf_logdrain_image
}


resource "cloudfoundry_app" "loki" {
  name         = "tf-loki-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = var.loki_image
  environment = merge({
    LOKI_YAML_BASE64 = base64encode(templatefile("${path.module}/templates/loki.yaml", {
      //noinspection HILUnresolvedReference
      s3_access_key = cloudfoundry_service_key.s3.credentials.api_key
      //noinspection HILUnresolvedReference
      s3_secret_access_key = cloudfoundry_service_key.s3.credentials.secret_key
      //noinspection HILUnresolvedReference
      s3_endpoint = cloudfoundry_service_key.s3.credentials.endpoint
      //noinspection HILUnresolvedReference
      s3_bucket = cloudfoundry_service_key.s3.credentials.bucket
      //noinspection HILUnresolvedReference
      apps_internal_host = cloudfoundry_route.loki_internal.endpoint
      //noinspection HILUnresolvedReference
      max_query_series = var.max_query_series
    }))
  }, var.environment)
  command = "echo $LOKI_YAML_BASE64 | base64 -d > /loki/loki.yaml && /usr/bin/loki -config.file=/loki/loki.yaml"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.loki_internal.id
  }

  labels = {
    "variant.tva/exporter" = true,
  }
  annotations = {
    "prometheus.exporter.port" = "3100"
    "prometheus.exporter.path" = "/metrics"
  }
}

resource "cloudfoundry_route" "loki_internal" {
  domain   = data.cloudfoundry_domain.internal.id
  space    = var.cf_space_id
  hostname = "tf-loki-${local.postfix}"
}

resource "cloudfoundry_network_policy" "loki" {
  count = length(var.network_policies) > 0 ? 1 : 0

  dynamic "policy" {
    for_each = [for p in var.network_policies : {
      //noinspection HILUnresolvedReference
      destination_app = p.destination_app
      //noinspection HILUnresolvedReference
      port = p.port
      //noinspection HILUnresolvedReference
      protocol = p.protocol
    }]
    content {
      source_app      = cloudfoundry_app.loki.id
      destination_app = policy.value.destination_app
      protocol        = policy.value.protocol == "" ? "tcp" : policy.value.protocol
      port            = policy.value.port
    }
  }
}
