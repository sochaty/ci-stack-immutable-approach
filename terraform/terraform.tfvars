region = "us-east-1"
# VPC variables for specific environment
vpc_cidr    = "10.0.0.0/16"
environment = "Development"
# "10.0.5.0/24"
public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
# "10.0.6.0/24"
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
# "c"
zones             = ["a", "b"]
image_id          = "ami-0b5eea76982371e91"
instance_type     = "t2.micro"
min_instance_size = 2
max_instance_size = 10
key_pair_name     = "demokey1"

win_ec2_image_id = "ami-0c4af4610ab22c4f4"
win_ec2_instance_type = "t2.micro"