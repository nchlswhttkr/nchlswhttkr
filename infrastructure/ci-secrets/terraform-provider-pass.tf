resource "aws_s3_object" "terraform_provider_pass_environment" {
  bucket                 = var.buildkite_secrets_bucket_name
  key                    = "terraform-provider-pass/environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail
    export BUILDKITE_GIT_FETCH_FLAGS="-v --prune --tags"
  EOF
}
