locals {
  deploy_key_for_pipeline_to_repo = {
    "bandcamp-mini-embed"     = "bandcamp-mini-embed"
    "terraform-provider-pass" = "terraform-provider-pass"
    "website"                 = "website"
  }
}

resource "tls_private_key" "ssh_deploy_key" {
  for_each = local.deploy_key_for_pipeline_to_repo

  algorithm = "ED25519"
}

resource "aws_s3_object" "ssh_deploy_key" {
  for_each = local.deploy_key_for_pipeline_to_repo

  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "${each.key}/private_ssh_key"
  server_side_encryption = "aws:kms"
  content                = tls_private_key.ssh_deploy_key[each.key].private_key_openssh
}

resource "github_repository_deploy_key" "terraform_provider_pass" {
  for_each = local.deploy_key_for_pipeline_to_repo

  title      = "Allow SSH access to ${each.value} from Buildkite pipeline ${each.key}"
  repository = "terraform-provider-pass"
  read_only  = true
  key        = tls_private_key.ssh_deploy_key[each.key].public_key_openssh
}
