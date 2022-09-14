.PHONY: infra
infra:
	@terraform -chdir=infrastructure init
	@terraform -chdir=infrastructure apply
