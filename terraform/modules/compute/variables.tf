variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}


variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "image_owner" {
  type        = string
  description = "Image owner"
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

variable "jumpbox_image_id" {
  type = string
  description = "Jumpbox EC2 imageid"
}

variable "jumpbox_type" {
  type = string
  description = "Jumpbox EC2 Type"
}

variable "jumpbox_name" {
  type = string
  description = "Jumpbox EC2 Name"
}