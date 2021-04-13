output "loki_endpoint" {
  description = "The endpoint where Loki is reachable on"
  value       = cloudfoundry_route.loki.endpoint
}

output "loki_id" {
  description = "The Loki apps' id"
  value       = cloudfoundry_app.loki.id
}
