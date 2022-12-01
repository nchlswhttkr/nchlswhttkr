terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    github = {
      source  = "integrations/github"
      version = ">= 4.0"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = ">= 0.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.pass_password.aws_access_key_id.password
  secret_key = data.pass_password.aws_access_key_secret.password
  default_tags {
    tags = {
      Project = "Elastic Buildkite Stack"
    }
  }
}

data "pass_password" "aws_access_key_id" {
  name = "website/aws-access-key-id"
}

data "pass_password" "aws_access_key_secret" {
  name = "website/aws-access-key-secret"
}
