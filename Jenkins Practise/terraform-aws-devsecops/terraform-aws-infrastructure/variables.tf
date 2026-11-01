variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project tag/name prefix."
  type        = string
  default     = "devsecops-demo"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnet."
  type        = string
}

variable "ami_id" {
  description = "Approved Amazon Linux AMI ID for this region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "app_bucket_name" {
  description = "Globally unique name for the application S3 bucket."
  type        = string
}
