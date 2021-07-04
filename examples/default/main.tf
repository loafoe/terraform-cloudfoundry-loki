data "hsdp_config" "cf" {
  service = "cf"
}

module "loki" {
  source      = "../../"
  cf_domain   = data.hsdp_config.cf.domain
  cf_space_id = "test"
}