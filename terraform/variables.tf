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

variable "jenkins_machine_data" {
  type = object({
    name  = string
    image = string
    type  = string
  })
  description = "Jenkins machine data"
}

variable "nexus_machine_data" {
  type = object({
    name  = string
    image = string
    type  = string
  })
  description = "Nexus machine data"
}

variable "sonarqube_machine_data" {
  type = object({
    name  = string
    image = string
    type  = string
  })
  description = "Sonarqube machine data"
}

variable "postgres_machine_data" {
  type = object({
    name  = string
    image = string
    type  = string
  })
  description = "Postgres machine data"
}

variable "key_pair_name" {
  #   default     = "myEC2KeyPair"
  description = "Key pair for connecting to launched EC2 instances"
  type        = string
}

variable "image_owner" {
  type        = string
  description = "Image owner"
}
variable "jumpbox_image_id" {
  type        = string
  description = "Jumpbox EC2 imageid"
}

variable "jumpbox_type" {
  type        = string
  description = "Jumpbox EC2 Type"
}

variable "jumpbox_name" {
  type        = string
  description = "Jumpbox EC2 Name"
}