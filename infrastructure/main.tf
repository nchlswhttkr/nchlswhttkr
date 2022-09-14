terraform {
  required_version = ">= 1.2.8"

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/nchlswhttkr.tfstate"
  }
}

module "buildkite" {
  source = "./elastic-buildkite-stack"
}
