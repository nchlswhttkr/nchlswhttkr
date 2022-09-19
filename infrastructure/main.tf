terraform {
  required_version = ">= 1.2.8"

  required_providers {
    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }
  }

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/nchlswhttkr.tfstate"
  }
}

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}

module "buildkite" {
  source = "./elastic-buildkite-stack"
  providers = {
    pass = pass
  }
}

module "ci_secrets" {
  source = "./ci-secrets"
  providers = {
    pass = pass
  }

  buildkite_secrets_bucket_name = module.buildkite.secrets_bucket_name
}
