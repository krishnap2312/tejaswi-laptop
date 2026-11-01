# terraform-aws-infrastructure

Consumer repository for reusable modules from `terraform-aws-modules`.

## Before first run

1. Replace the example module Git URL and release tag in `main.tf`.
2. Replace the placeholder S3 backend bucket in `backend.tf`.
3. Replace the example AMI ID in each environment tfvars with an approved AMI ID for the chosen AWS region.
4. Confirm the configured Availability Zone exists in the account/region.
5. Ensure the Jenkins agent's AWS role can manage only the required resources and access the state bucket.
6. Ensure the Jenkins agent can clone the private module repository using the configured SSH deploy key.

## Commands

```bash
terraform fmt -check -recursive
terraform init -backend-config="environments/dev/backend.hcl"
terraform validate
checkov -d . --framework terraform --config-file .checkov.yaml
terraform plan -var-file="environments/dev/terraform.tfvars"
```

Never commit real secrets. Keep state, saved plans, and logs access restricted.
