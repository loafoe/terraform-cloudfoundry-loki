variable "loki_image" {
  type        = string
  description = "Loki Docker image to use"
  default     = "grafana/loki:2.8.0"
}
variable "loki_cf_logdrain_image" {
  type        = string
  description = "loki-cf-logdrain Docker image to use"
  default     = "ghcr.io/philips-software/loki-cf-logdrain:v0.5.6"
}

variable "cf_domain" {
  type        = string
  description = "The CF domain name to use"
}

variable "cf_space_id" {
  type        = string
  description = "The CF Space to deploy in"
}

variable "name_postfix" {
  type        = string
  description = "The postfix string to append to the hostname, prevents namespace clashes"
  default     = ""
}
variable "environment" {
  type        = map(any)
  description = "Environment variables for Grafana Loki"
  default     = {}
}

variable "enable_public_proxy" {
  type        = bool
  description = "Enables an authenticated public proxy endpoint"
  default     = false
}

variable "enable_cf_logdrain" {
  type        = bool
  description = "Enables creation of a Cloud foundry logdrain service"
  default     = false
}

variable "s3_broker_settings" {
  type = object({
    service_broker = string
    service_plan   = string
  })
  default = {
    service_broker = "hsdp-s3"
    service_plan   = "s3_bucket"
  }
  description = "The S3 service broker to use"
}

variable "s3_credentials" {
  type = object({
    access_key = string
    secret_key = string
    endpoint   = string
    bucket     = string
  })
  default = {
    access_key = ""
    secret_key = ""
    endpoint   = ""
    bucket     = ""
  }
}

variable "network_policies" {
  description = "The container-to-container network policies to create with Grafana as the source app"
  type = list(object({
    destination_app = string
    protocol        = string
    port            = string
  }))
  default = []
}

variable "memory" {
  type        = number
  description = "The amount of RAM to allocate for Loki (MB)"
  default     = 1024
}

variable "disk" {
  type        = number
  description = "The amount of Disk space to allocate for Grafana Loki (MB)"
  default     = 4096
}

variable "docker_username" {
  type        = string
  description = "Docker registry username"
  default     = ""
}

variable "docker_password" {
  type        = string
  description = "Docker registry password"
  default     = ""
}

variable "caddy_image" {
  type        = string
  description = "Caddy server image to use"
  default     = "caddy/caddy:2.6.1"
}

variable "max_query_series" {
  type        = number
  description = "Maximum query series"
  default     = 500
}
