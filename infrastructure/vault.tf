resource "vault_mount" "kv" {
  path = "kv"
  type = "kv-v2"
}

resource "vault_policy" "buildkite" {
  name   = "buildkite"
  policy = <<-POLICY
    path "${vault_mount.kv.path}/data/buildkite/*" {
      capabilities = ["read"]
    }
  POLICY
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "buildkite" {
  backend        = vault_auth_backend.approle.path
  role_name      = "buildkite"
  token_policies = ["default", vault_policy.buildkite.name]
}

resource "vault_approle_auth_backend_role_secret_id" "buildkite" {
  role_name = vault_approle_auth_backend_role.buildkite.role_name
}
