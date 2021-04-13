terraform {
  required_version = ">= 0.14.0"

  required_providers {
    cloudfoundry = {
      source  = "philips-labs/cloudfoundry"
      version = ">= 0.1400.0"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
