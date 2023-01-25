output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = data.aws_subnets.private-subnets.ids
}

output "public_subnet_ids" {
  value = data.aws_subnets.public-subnets.ids
}