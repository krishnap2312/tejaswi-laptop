# Replace YOUR-ORG and the tag with your real private Git repository and
# an immutable, reviewed module release.
locals {
  module_source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git"
}

module "vpc" {
  source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git//modules/vpc?ref=v1.0.0"

  name                = "${var.project_name}-${var.environment}"
  cidr_block          = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  environment         = var.environment
}

module "security_group" {
  source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git//modules/security-group?ref=v1.0.0"

  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "No inbound access by default; use SSM for administration."
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  ingress_rules = []
}

module "ec2_iam" {
  source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git//modules/iam-ec2-ssm?ref=v1.0.0"

  name        = "${var.project_name}-${var.environment}-ec2"
  environment = var.environment
}

module "ec2" {
  source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git//modules/ec2?ref=v1.0.0"

  name                   = "${var.project_name}-${var.environment}-instance"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_id
  security_group_ids     = [module.security_group.security_group_id]
  instance_profile_name  = module.ec2_iam.instance_profile_name
  associate_public_ip_address = false
  environment            = var.environment
}

module "app_bucket" {
  source = "git::ssh://git@github.com/YOUR-ORG/terraform-aws-modules.git//modules/s3?ref=v1.0.0"

  bucket_name = var.app_bucket_name
  environment = var.environment
}
