variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}


variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "image_id" {
  type        = string
  description = "AMI ID"
}

variable "key_pair_name" {
  #   default     = "myEC2KeyPair"
  description = "Key pair for connecting to launched EC2 instances"
  type        = string
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

variable "environment" {
  type    = string
  default = "Development"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public Subnet IDs"
}

variable "win_ec2_image_id" {
  type = string
  description = "Windows Test EC2 Private IP"
}

variable "win_ec2_instance_type" {
  type = string
  description = "Windows Test EC2 Private IP"
}

variable "win_ec2_subnet_id" {
  type = string
  description = "Subnet ID for Windows Test EC2"
}