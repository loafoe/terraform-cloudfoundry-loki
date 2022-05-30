output "proxy_username" {
  value = "loki"
}

output "proxy_password" {
  description = "The Loki proxy password. Username is always 'loki'"
  value       = random_password.proxy_password.result
  sensitive   = true
}

output "proxy_endpoint" {
  description = "The Loki proxy endpoint"
  value       = cloudfoundry_route.loki_proxy.endpoint
}
