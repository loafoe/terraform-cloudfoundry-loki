resource "cloudfoundry_app" "lokiproxy" {
  name         = "tf-lokiproxy-${local.postfix}"
  space        = var.cf_space_id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = var.lokiproxy_image
  environment = merge({
    TOKEN = random_password.token.result
    PROMTAIL_YAML_BASE64 = base64encode(templatefile("${path.module}/templates/promtail.yaml", {
      apps_internal_host = cloudfoundry_route.loki_internal.endpoint
    }))
  }, var.environment)

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.lokiproxy.id
  }
}

resource "cloudfoundry_route" "lokiproxy" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = var.cf_space_id
  hostname = "tf-lokiproxy-${local.postfix}"
}

resource "cloudfoundry_network_policy" "lokiproxy" {

  policy {
    source_app      = cloudfoundry_app.lokiproxy.id
    destination_app = cloudfoundry_app.loki.id
    protocol        = "tcp"
    port            = "3100"
  }
}

resource "cloudfoundry_user_provided_service" "logdrain" {
  name  = "tf-lokiproxy-${local.postfix}"
  space = var.cf_space_id
  //noinspection HILUnresolvedReference
  syslog_drain_url = "https://${cloudfoundry_route.lokiproxy.endpoint}/syslog/drain/${random_password.token.result}"
}

