output "internet-loadbalancer-dns" {
  value = aws_lb.internet_load_balancer.dns_name
}

output "internal-loadbalancer-dns" {
  value = aws_lb.internal_load_balancer.dns_name
}

output "internet-instance-ips" {
  value = data.aws_instances.public_instances.public_ips
}

output "internal-instance-private-ips" {
  value = data.aws_instances.private_instances.private_ips
}