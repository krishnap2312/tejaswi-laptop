# Terraform + AWS + Jenkins + Checkov DevSecOps Starter

This package contains **two separately deployable Git repositories**:

1. `terraform-aws-modules/` — reusable, versioned AWS Terraform modules.
2. `terraform-aws-infrastructure/` — environment configuration and the Jenkins deployment pipeline.

The examples target AWS in `ap-south-1` by default. Review every value and policy before using it in a real account.

## Architecture

```text
Module repository
  commit -> module CI -> fmt/validate -> Checkov -> tag release
                                              |
                                              v
Infrastructure repository
  commit/PR -> Jenkins -> checkout -> init -> fmt/validate
                         -> Checkov -> plan -> approval -> apply
                                                        |
                                                        v
                                                       AWS
                                  S3 remote state + state lock file
```

## Package contents

- VPC module: VPC, public subnet, internet gateway, route table.
- Security group module: configurable ingress; egress enabled.
- EC2 module: Amazon Linux 2023 instance, optional instance profile, no public IP by default.
- S3 module: versioning, server-side encryption, public access block.
- IAM module: EC2 role and instance profile with Systems Manager managed policy.
- Module CI Jenkinsfile and infrastructure CD Jenkinsfile.
- Checkov configuration, example environment variable files, backend configuration, and operational guidance.

## Prerequisites

- AWS account and an approved deployment role.
- Jenkins agent with Git, Terraform, AWS CLI, Python 3, Checkov, and the Jenkins SSH Agent and Pipeline plugins.
- Git server access for the infrastructure repository and private module repository.
- An S3 bucket created **before** Terraform init for remote state. Enable versioning, block public access, and restrict access to the Jenkins deployment role.
- A DynamoDB lock table is not required when using Terraform's S3 native lockfile (`use_lockfile = true`). Use a Terraform version that supports it.

## Recommended setup order

1. Create the state bucket manually or through a separate bootstrap process. Example bucket name: `YOUR-ORG-terraform-state-ACCOUNT-ID`.
2. Configure Jenkins agent AWS authentication using an instance profile, OIDC/federation, or approved short-lived role assumption. Avoid long-lived IAM user keys.
3. Push `terraform-aws-modules/` to a private Git repository.
4. Review the module code, run the module CI, and create a protected release tag such as `v1.0.0`.
5. Replace the example Git URL and tag in `terraform-aws-infrastructure/main.tf`.
6. Push `terraform-aws-infrastructure/` to its Git repository and configure a Jenkins Multibranch Pipeline or Pipeline-from-SCM job.
7. Set the Jenkins credential ID `terraform-modules-deploy-key` to a read-only SSH deploy key that can clone the module repository. Configure known_hosts / host-key verification on the agent.
8. Run `dev` first. Review the plan and Checkov report before approving apply.

## Important configuration

### Remote state

`terraform-aws-infrastructure/backend.tf` contains the S3 backend. The bucket name is a placeholder. Replace it with your pre-created bucket. The pipeline passes an environment-specific `backend.hcl` so dev, QA, and prod use separate state keys.

### Git module source

In `terraform-aws-infrastructure/main.tf`, replace:

```hcl
git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git
```

with your actual repository URL. Keep a release tag or immutable commit reference in `?ref=`. Do not use a moving branch for production.

### EC2 access

The example EC2 instance has no public IP and the security group has no inbound rules by default. The module attaches an SSM instance profile. To use Systems Manager, ensure the instance can reach the SSM endpoints through NAT or VPC endpoints and that the deployment account has the required SSM permissions. Do not open SSH to `0.0.0.0/0`.

### Secrets

Do not store credentials, private keys, passwords, or secrets in `.tfvars`, Git, Terraform outputs, or plan files. Terraform state and saved plan files can contain sensitive values. Restrict access and retention for Jenkins artifacts and S3 state.

## Run locally (optional)

From `terraform-aws-infrastructure/`:

```bash
terraform fmt -check -recursive
terraform init -backend-config="environments/dev/backend.hcl"
terraform validate
checkov -d . --framework terraform
terraform plan -var-file="environments/dev/terraform.tfvars"
```

To apply locally, use an authorized AWS identity and review the plan first:

```bash
terraform apply -var-file="environments/dev/terraform.tfvars"
```

## Jenkins pipeline notes

- The infrastructure Jenkinsfile uses the `terraform-agent` label.
- The AWS identity is expected to be available to the agent before pipeline execution.
- The private module clone uses Jenkins SSH Agent credential `terraform-modules-deploy-key`.
- `terraform init` downloads the private module; Git host keys must be pre-trusted on the agent.
- The pipeline creates and applies the same saved plan artifact (`tfplan`) so the applied change matches the reviewed plan.
- Production approval should be restricted with Jenkins authorization / input submitter controls. The example includes an approver group placeholder.
- `disableConcurrentBuilds()` serializes this job; still use separate state keys and locking for other jobs.
- Do not publish saved plan files as broadly accessible artifacts. The sample archives only a human-readable plan; review artifact access controls.

## Security and operational checklist

- [ ] Use a dedicated least-privilege AWS role for Terraform.
- [ ] Limit the role to approved accounts, regions, and resource scopes where practical.
- [ ] Enable CloudTrail and appropriate AWS monitoring.
- [ ] Protect main branches and require pull-request review.
- [ ] Sign/protect module release tags and pin module versions.
- [ ] Pin Terraform and provider versions; review provider lock file changes.
- [ ] Keep Checkov findings as a blocking gate; document and time-limit any exception.
- [ ] Review Checkov policy coverage and tune `.checkov.yaml` only with security approval.
- [ ] Keep state bucket private, encrypted, versioned, and access-logged.
- [ ] Restrict plan, state, and build log access.
- [ ] Test changes in non-production before production.
- [ ] Define recovery, state backup, and incident procedures.

## Cleanup

Destroy only after confirming the target workspace/state and reviewing the destroy plan:

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

The S3 remote-state bucket is intentionally not managed by this sample stack. Keep it until the state is no longer needed.
