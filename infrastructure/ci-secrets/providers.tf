terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

    pass = {
      source  = "nicholas.cloud/nchlswhttkr/pass"
      version = ">= 0.1"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-2"
  access_key = data.pass_password.aws_access_key_id.password
  secret_key = data.pass_password.aws_access_key_secret.password
}

data "pass_password" "aws_access_key_id" {
  name = "website/aws-access-key-id"
}

data "pass_password" "aws_access_key_secret" {
  name = "website/aws-access-key-secret"
}
