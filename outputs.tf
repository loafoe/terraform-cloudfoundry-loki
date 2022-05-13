output "loki_endpoint" {
  description = "The endpoint where Loki is reachable on"
  //noinspection HILUnresolvedReference
  value = cloudfoundry_route.loki_internal.endpoint
}

output "loki_app_id" {
  description = "The Loki app id"
  value       = cloudfoundry_app.loki.id
}

output "loki_proxy_password" {
  description = "The Loki proxy password. Username is always 'loki'"
  value       = random_password.proxy_password.result
  sensitive   = true
}

output "logdrain_endpoint" {
  description = "The logproxy logdrain endpoint"
  value       = "https://${cloudfoundry_route.loki_cf_logdrain.endpoint}/syslog/drain/${random_password.token.result}"
  sensitive   = true
}

output "logdrain_service_id" {
  description = "The uuid of the logdrain service. You can bind this to your app to enable logdraining"
  value       = cloudfoundry_user_provided_service.logdrain.id
}
