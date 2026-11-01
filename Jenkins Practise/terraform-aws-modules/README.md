# terraform-aws-modules

Reusable AWS Terraform modules. Publish this directory as its own Git repository.

## Modules

- `modules/vpc`
- `modules/security-group`
- `modules/ec2`
- `modules/s3`
- `modules/iam-ec2-ssm`

## Release process

1. Pull request and review.
2. Run `terraform fmt -check -recursive`.
3. Run `terraform init` and `terraform validate` in each module (see Jenkinsfile).
4. Run Checkov.
5. Test in a sandbox AWS account.
6. Create a protected semantic version tag, for example `v1.0.0`.
7. Consumers pin `?ref=v1.0.0`.

Modules are intentionally small and composable. Review variable defaults and security policies before release.
