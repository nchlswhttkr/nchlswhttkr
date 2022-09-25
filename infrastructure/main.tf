terraform {
  required_version = ">= 1.2.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.13"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = "~> 0.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

  }

  backend "local" {
    path = "/Users/nchlswhttkr/Google Drive/nicholas.cloud/nchlswhttkr.tfstate"
  }
}

provider "pass" {
  store = "/Users/nchlswhttkr/Google Drive/.password-store"
}

provider "github" {
  token = data.pass_password.github_secret_token.password
}

data "pass_password" "github_secret_token" {
  name = "website/github-access-token"
}

module "buildkite" {
  source = "./elastic-buildkite-stack"
  providers = {
    pass   = pass
    github = github
  }
}
