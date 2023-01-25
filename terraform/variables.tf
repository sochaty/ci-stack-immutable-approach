variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "environment" {
  description = "Environment"
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

variable "image_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  description = "EC2 Instance type to launch"
  type        = string
}

variable "min_instance_size" {
  type        = number
  description = "Minimum number of instances to launch in AutoScaling Group"
}

variable "max_instance_size" {
  type        = number
  description = "Maximum number of instances to launch in AutoScaling Group"
}

variable "key_pair_name" {
  #   default     = "myEC2KeyPair"
  description = "Key pair for connecting to launched EC2 instances"
  type        = string
}

variable "win_ec2_image_id" {
  type = string
  description = "Windows Test EC2 Private IP"
}

variable "win_ec2_instance_type" {
  type = string
  description = "Windows Test EC2 Private IP"
}