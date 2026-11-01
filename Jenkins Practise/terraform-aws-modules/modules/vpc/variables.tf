variable "name" {
  description = "Name prefix for VPC resources."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the public subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet."
  type        = string
}

variable "environment" {
  description = "Environment tag."
  type        = string
}
