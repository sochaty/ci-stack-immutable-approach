terraform {
  #   required_version = ">= 4.48.0"
  backend "s3" {
    bucket = "vpc-solutions-terraform-demo"
    key    = "dev/vpc-with-ec2/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "vpc-solution"
  }
}

provider "aws" {
  region = var.region
}