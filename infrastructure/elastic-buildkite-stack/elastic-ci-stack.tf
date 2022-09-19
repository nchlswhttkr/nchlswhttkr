resource "aws_cloudformation_stack" "buildkite" {
  name         = "elastic-buildkite-stack"
  template_url = "https://s3.amazonaws.com/buildkite-aws-stack/latest/aws-stack.yml"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    BuildkiteAgentTokenParameterStorePath   = resource.aws_ssm_parameter.buildkite_agent_token.name
    BuildkiteAgentTokenParameterStoreKMSKey = data.aws_kms_key.default.id
    InstanceType                            = "t3a.small"
    RootVolumeSize                          = 25
    OnDemandPercentage                      = 0
  }
}

data "aws_kms_key" "default" {
  key_id = "alias/aws/ssm"

  depends_on = [
    aws_ssm_parameter.buildkite_agent_token
  ]
}

output "secrets_bucket_name" {
  value = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
}
