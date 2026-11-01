variable "name" {
  description = "Security group name."
  type        = string
}

variable "description" {
  description = "Security group description."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created."
  type        = string
}

variable "environment" {
  description = "Environment tag."
  type        = string
}

variable "ingress_rules" {
  description = "Ingress rules. Keep empty unless access is explicitly required."
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
