output "vpc_id" {
  description = "Created VPC ID."
  value       = module.vpc.vpc_id
}

output "ec2_instance_id" {
  description = "Created EC2 instance ID."
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "EC2 private IP."
  value       = module.ec2.private_ip
}

output "app_bucket_name" {
  description = "Application bucket name."
  value       = module.app_bucket.bucket_id
}
