resource "aws_instance" "jumpbox_server" {
  ami                         = var.jumpbox_image_id # us-west-2
  instance_type               = var.jumpbox_type
  key_name                    = var.key_pair_name
  subnet_id                   = tolist(var.public_subnet_ids)[1]
  associate_public_ip_address = true
  security_groups             = [aws_security_group.jumpbox_sg.id]
  tags = {
    "Name" = var.jumpbox_name
  }
  depends_on = [
    aws_security_group.jumpbox_sg
  ]
}