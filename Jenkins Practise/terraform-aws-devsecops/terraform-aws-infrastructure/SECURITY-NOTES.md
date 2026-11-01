# Security notes and limitations

This is a starter implementation, not a turnkey production landing zone.

## Items that must be completed before production

1. Replace all placeholders, especially state bucket, Git organization, AMI IDs, and S3 bucket names.
2. Use a dedicated AWS deployment role with least privilege and short-lived credentials.
3. Scope state-bucket access to the required bucket and object prefixes. Enable bucket versioning, encryption, public-access blocking, and access logging as required by policy.
4. Protect module release tags and use immutable versions. Consider pinning a commit SHA for highly controlled releases.
5. Configure Jenkins authorization so only an approved group can approve production. The example `aws-prod-approvers` is a Jenkins user/group name placeholder.
6. Configure Git SSH host-key verification on Jenkins agents. Do not use insecure host-key bypasses.
7. Restrict access to Jenkins workspaces, logs, plan artifacts, and Checkov reports.
8. Review all Checkov findings. Do not globally suppress checks to make a build pass.
9. Add policy tests and integration tests for module behavior. Run in a sandbox account before release.
10. Consider separate AWS accounts for dev, QA, and prod, with role assumption into each account.

## Network caveat

The sample VPC creates an internet gateway and a subnet with a public route, but the EC2 instance has no public IP and the security group has no ingress rules. This is intentionally restrictive. The instance will not have general outbound internet access without a NAT gateway or suitable VPC endpoints. For Systems Manager, add the required SSM interface endpoints or a controlled egress path.

## IAM caveat

The sample EC2 role attaches `AmazonSSMManagedInstanceCore`. This is an AWS-managed policy for the instance's SSM agent. Review whether your organization's policy permits it or requires a narrower customer-managed policy.

## Terraform state and plan sensitivity

Terraform state and saved plan files may include sensitive values. Never commit them. Do not make them publicly downloadable. The pipeline archives only the human-readable plan; even that artifact should have restricted access.
