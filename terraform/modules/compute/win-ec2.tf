resource "aws_instance" "test_instance" {
  ami           = var.win_ec2_image_id # us-west-2
  instance_type = var.win_ec2_instance_type
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  subnet_id   = var.win_ec2_subnet_id
  security_groups = [ aws_security_group.win_ec2_instance_security_group.id ]


  credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    "Name" = "${var.environment}-Win-Instance"
  }
}