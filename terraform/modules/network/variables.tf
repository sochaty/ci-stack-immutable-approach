variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "environment" {
  description = "Environment"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "CIDR address for public subnets"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "CIDR address for private subnets"
}

variable "zones" {
  type        = list(string)
  description = "Availability zones for subnet deployment"
}