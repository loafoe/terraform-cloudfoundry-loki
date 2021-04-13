data "cloudfoundry_org" "org" {
  name = var.cf_org
}
data "cloudfoundry_space" "space" {
  org  = data.cloudfoundry_org.org.id
  name = var.cf_space
}

data "cloudfoundry_service" "s3" {
  name = var.s3_broker_settings.service_broker
}

data "cloudfoundry_domain" "domain" {
  name = var.cf_domain
}

data "cloudfoundry_domain" "internal" {
  name = "apps.internal"
}

resource "cloudfoundry_app" "loki" {
  name         = "loki"
  space        = data.cloudfoundry_space.space.id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = var.loki_image
  environment = merge({}, var.environment)

  routes {
    route = cloudfoundry_route.loki.id
  }
  routes {
    route = cloudfoundry_route.loki_internal.id
  }
}

resource "cloudfoundry_route" "loki" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = var.name_postfix == "" ? "loki" : "loki-${var.name_postfix}"
}

resource "cloudfoundry_route" "loki_internal" {
  domain = data.cloudfoundry_domain.internal.id
  space = data.cloudfoundry_space.space.id
  hostname = var.name_postfix == "" ? "loki" : "loki-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "loki" {
  count = length(var.network_policies) > 0 ? 1 : 0

  dynamic "policy" {
    for_each = [for p in var.network_policies : {
      destination_app = p.destination_app
      port            = p.port
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
