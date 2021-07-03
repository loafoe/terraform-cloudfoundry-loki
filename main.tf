data "cloudfoundry_service" "s3" {
  name = var.s3_broker_settings.service_broker
}

data "cloudfoundry_domain" "internal" {
  name = "apps.internal"
}

resource "cloudfoundry_app" "loki" {
  name         = "loki"
  space        = var.cf_space_id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = var.loki_image
  environment = merge({
    LOKI_YAML_BASE64 = base64encode(templatefile("${path.module}/templates/loki.yaml", {
      s3_access_key        = var.s3_credentials.access_key
      s3_secret_access_key = var.s3_credentials.secret_key
      s3_endpoint          = var.s3_credentials.endpoint
      s3_bucket            = var.s3_credentials.bucket
    }))
  }, var.environment)
  command = "/loki/run.sh"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.loki_internal.id
  }
}

resource "cloudfoundry_route" "loki_internal" {
  domain   = data.cloudfoundry_domain.internal.id
  space    = var.cf_space_id
  hostname = var.name_postfix == "" ? "loki" : "loki-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "loki" {
  count = length(var.network_policies) > 0 ? 1 : 0

  dynamic "policy" {
    for_each = [for p in var.network_policies : {
      //noinspection HILUnresolvedReference
      destination_app = p.destination_app
      //noinspection HILUnresolvedReference
      port            = p.port
      //noinspection HILUnresolvedReference
      protocol        = p.protocol
    }]
    content {
      source_app      = cloudfoundry_app.loki.id
      destination_app = policy.value.destination_app
      protocol        = policy.value.protocol == "" ? "tcp" : policy.value.protocol
      port            = policy.value.port
    }
  }
}
