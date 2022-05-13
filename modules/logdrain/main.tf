resource "random_password" "token" {
  length  = 32
  special = false
}

resource "cloudfoundry_app" "loki_cf_logdrain" {
  name         = "tf-loki-logdrain-${var.name_postfix}"
  space        = var.cf_space_id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = var.loki_cf_logdrain_image
  environment = merge({
    TOKEN = random_password.token.result
    PROMTAIL_YAML_BASE64 = base64encode(templatefile("${path.module}/templates/promtail.yaml", {
      apps_internal_host = var.loki_internal_endpoint
    }))
  }, {})

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.loki_cf_logdrain.id
  }
}

resource "cloudfoundry_route" "loki_cf_logdrain" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = var.cf_space_id
  hostname = "tf-loki-logdrain-${var.name_postfix}"
}

resource "cloudfoundry_network_policy" "loki_cf_logdrain" {

  policy {
    source_app      = cloudfoundry_app.loki_cf_logdrain.id
    destination_app = var.loki_app_id
    protocol        = "tcp"
    port            = "3100"
  }
}

resource "cloudfoundry_user_provided_service" "logdrain" {
  name  = "tf-loki-logdrain-${var.name_postfix}"
  space = var.cf_space_id
  //noinspection HILUnresolvedReference
  syslog_drain_url = "https://${cloudfoundry_route.loki_cf_logdrain.endpoint}/syslog/drain/${random_password.token.result}"
}
