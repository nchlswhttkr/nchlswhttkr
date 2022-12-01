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

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.10"
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
  token = data.vault_kv_secret_v2.github.data.access_token
}

data "vault_kv_secret_v2" "github" {
  mount = "kv"
  name  = "nchlswhttkr/github"
}

provider "vault" {
  address = "http://phoenix:8200"
  token   = var.vault_token
}

variable "vault_token" {
  description = "The authentication token to use with Hashicorp Vault for credentials"
  type        = string
}

module "buildkite" {
  source = "./elastic-buildkite-stack"
  providers = {
    pass   = pass
    github = github
  }

  vault_role_id   = vault_approle_auth_backend_role.buildkite.role_id
  vault_secret_id = vault_approle_auth_backend_role_secret_id.buildkite.secret_id
}
