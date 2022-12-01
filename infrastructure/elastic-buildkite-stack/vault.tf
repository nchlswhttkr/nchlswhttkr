resource "aws_ssm_parameter" "vault_role_id" {
  name  = "/elastic-buildkite-stack/vault-role-id"
  type  = "SecureString"
  value = var.vault_role_id
}

resource "aws_ssm_parameter" "vault_secret_id" {
  name  = "/elastic-buildkite-stack/vault-secret-id"
  type  = "SecureString"
  value = var.vault_secret_id
}

variable "vault_role_id" {
  description = "The role ID of the Vault role to assume"
  type        = string
}

variable "vault_secret_id" {
  description = "The secret ID of the Vault role to assume"
  type        = string
}
