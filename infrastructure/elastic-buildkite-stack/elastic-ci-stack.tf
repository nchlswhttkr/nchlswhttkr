resource "aws_cloudformation_stack" "buildkite" {
  name         = "elastic-buildkite-stack"
  template_url = "https://s3.amazonaws.com/buildkite-aws-stack/v5.11.1/aws-stack.yml"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    # https://buildkite.com/docs/agent/v3/elastic-ci-aws/parameters
    BuildkiteAgentTokenParameterStorePath   = resource.aws_ssm_parameter.buildkite_agent_token.name
    BuildkiteAgentTokenParameterStoreKMSKey = data.aws_kms_key.default.id

    # Auto-scaling EC2 instances
    MaxSize            = 3
    InstanceType       = "t3a.micro"
    RootVolumeSize     = 20
    OnDemandPercentage = 0

    # Buildkite agent settings
    AgentsPerInstance         = 2
    ScaleInIdlePeriod         = 300 # 5 minutes
    BuildkiteAgentExperiments = "ansi-timestamps,resolve-commit-after-checkout"
  }
}

data "aws_kms_key" "default" {
  key_id = "alias/aws/ssm"

  depends_on = [
    aws_ssm_parameter.buildkite_agent_token
  ]
}
