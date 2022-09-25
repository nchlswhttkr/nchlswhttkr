resource "aws_s3_object" "terraform_provider_pass_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "terraform-provider-pass/environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail
    export BUILDKITE_GIT_FETCH_FLAGS="-v --prune --tags"
  EOF
}

resource "aws_s3_object" "website_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "website/environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail
    if [[ "$BUILDKITE_STEP_KEY" =~ "(preview|publish)-newsletter-.*" ]]; then
      export MAILGUN_API_KEY="${data.pass_password.website_mailgun_api_key.password}"
    fi
    if [[ "$BUILDKITE_STEP_KEY" == "purge-cloudflare-cache" ]]; then
      export CLOUDFLARE_API_TOKEN="${data.pass_password.website_cloudflare_api_token.password}"
      export CLOUDFLARE_ZONE_ID="${data.pass_password.website_cloudflare_zone_id.password}"
    fi
  EOF
}

data "pass_password" "website_mailgun_api_key" {
  name = "website/mailgun-api-key"
}

data "pass_password" "website_cloudflare_api_token" {
  name = "website/cloudflare-api-token"
}

data "pass_password" "website_cloudflare_zone_id" {
  name = "website/cloudflare-zone-id"
}

resource "aws_s3_object" "bandcamp_mini_embed_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "bandcamp-mini-embed/environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail
    if [[ "$BUILDKITE_STEP_KEY" =~ "deploy" ]]; then
      export CLOUDFLARE_ACCOUNT_ID="${data.pass_password.bandcamp_mini_embed_cloudflare_account_id.password}"
      export CLOUDFLARE_API_TOKEN="${data.pass_password.bandcamp_mini_embed_cloudflare_api_token.password}"
    fi
  EOF
}

data "pass_password" "bandcamp_mini_embed_cloudflare_api_token" {
  name = "bandcamp-mini-embed/cloudflare-api-token"
}

data "pass_password" "bandcamp_mini_embed_cloudflare_account_id" {
  name = "bandcamp-mini-embed/cloudflare-account-id"
}
