.PHONY: infra
infra:
	@terraform -chdir=infrastructure init
	@terraform -chdir=infrastructure apply -var "vault_token=$(shell pass show vault/root-token)"
