# output "internet-loadbalancer-dns" {
#   value = aws_lb.internet_load_balancer.dns_name
# }

# output "internal-loadbalancer-dns" {
#   value = aws_lb.internal_load_balancer.dns_name
# }

# output "internet-instance-ips" {
#   value = data.aws_instances.public_instances.public_ips
# }

output "postgres_host_ipaddress" {
  value = data.aws_instance.postgres_server_instance.private_ip
}