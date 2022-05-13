output "loki_endpoint" {
  description = "The endpoint where Loki is reachable on"
  //noinspection HILUnresolvedReference
  value = cloudfoundry_route.loki_internal.endpoint
}

output "loki_app_id" {
  description = "The Loki app id"
  value       = cloudfoundry_app.loki.id
}

output "loki_public_proxy_password" {
  description = "The Loki proxy password. Username is always 'loki'"
  value       = module.proxy.*.proxy_password
  sensitive   = true
}

output "loki_public_proxy_username" {
  description = "The Loki proxy password. Username is always 'loki'"
  value       = module.proxy.*.proxy_username
  sensitive   = true
}


output "logdrain_endpoint" {
  description = "The logproxy logdrain endpoint"
  value       = module.logdrain.*.logdrain_endpoint
  sensitive   = true
}

output "logdrain_service_id" {
  description = "The uuid of the logdrain service. You can bind this to your app to enable logdraining"
  value       = module.logdrain.*.logdrain_service_id
}
