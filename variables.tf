variable "loki_image" {
  type        = string
  description = "Loki Docker image to use"
  default     = "philipslabs/cf-loki:latest"
}
variable "lokiproxy_image" {
  type        = string
  description = "lokiproxy Docker image to use"
  default     = "loafoe/lokiproxy:latest"
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
