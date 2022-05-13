output "proxy_username" {
  value = "loki"
}

output "proxy_password" {
  description = "The Loki proxy password. Username is always 'loki'"
  value       = random_password.proxy_password.result
  sensitive   = true
}
