data "pass_password" "buildkite_agent_token" {
  name = "website/buildkite-agent-token"
}

resource "aws_ssm_parameter" "buildkite_agent_token" {
  name  = "/elastic-buildkite-stack/buildkite-agent-token"
  type  = "SecureString"
  value = data.pass_password.buildkite_agent_token.password
}
