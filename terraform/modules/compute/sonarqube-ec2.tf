data "aws_ami" "latest_sonarqube_image" {
  most_recent = true
  owners      = ["${var.image_owner}"] # Canonical

  filter {
    name   = "name"
    values = ["${var.sonarqube_machine_data.image}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "sonarqube_server" {
  ami             = data.aws_ami.latest_sonarqube_image.id # us-west-2
  instance_type   = var.sonarqube_machine_data.type
  key_name        = var.key_pair_name
  subnet_id       = tolist(var.private_subnet_ids)[0]
  security_groups = [aws_security_group.sonarqube_sg.id]
  tags = {
    "Name" = var.sonarqube_machine_data.name
  }
  depends_on = [
    aws_security_group.sonarqube_sg,
    aws_instance.postgres_server
  ]
}