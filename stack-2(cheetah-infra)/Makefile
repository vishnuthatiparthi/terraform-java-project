# Makefile  to interact with Terraform.

REGION=us-east-1
ENVNAME=development
ACCOUNT=mars
TFSTATEBUCKET=cheetah-$(ACCOUNT)-$(ENVNAME)-$(REGION)-tfstate
TFSTATEFILE=tfstate/$(ENVNAME).tfstate
TFDIR=.

# Default target
.PHONY: all
all: plan

# ------------------------
# Terraform Commands
# ------------------------

.PHONY: init
init:
	@echo "Initializing Terraform with backend: $(TFSTATEBUCKET)"
	cd $(TFDIR) && terraform init

.PHONY: validate
validate:
	@echo "Validating Terraform Configuration"
	cd $(TFDIR) && terraform validate

.PHONY: fmt
fmt:
	@echo "Formatting Terraform Configuration"
	cd $(TFDIR) && terraform fmt

.PHONY: plan
plan:
	@echo "Planning Terraform Changes For $(ENVNAME)"
	cd $(TFDIR) && terraform plan -var-file=./environments/$(ENVNAME)/params.tfvars

.PHONY: apply
apply:
	@echo "Applying Terraform Changes To $(ENVNAME)"
	cd $(TFDIR) && terraform apply -var-file=./environments/$(ENVNAME)/params.tfvars

.PHONY: destroy
destroy:
	echo "Destroying Terraform Changes On Environment $(ENVNAME)"
	cd $(TFDIR) && terraform destroy -var-file=./environments/$(ENVNAME)/params.tfvars

.PHONY: output
output:
	cd $(TFDIR) && terraform output

.PHONY: clean
clean:
	echo "Cleaning Up Terraform Cache And State File"
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup