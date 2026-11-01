variable "name" {
  description = "Name prefix for the EC2 role and instance profile."
  type        = string
}

variable "environment" {
  description = "Environment tag."
  type        = string
}
