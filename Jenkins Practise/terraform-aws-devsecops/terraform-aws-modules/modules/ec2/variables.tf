variable "name" {
  description = "EC2 instance name."
  type        = string
}

variable "ami_id" {
  description = "Approved AMI ID for the target region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs."
  type        = list(string)
}

variable "instance_profile_name" {
  description = "Optional EC2 instance profile name."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IPv4 address."
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment tag."
  type        = string
}
