data "aws_ami" "latest_jenkins_image" {
  most_recent = true
  owners      = ["${var.image_owner}"] # Canonical

  filter {
    name   = "name"
    values = ["${var.jenkins_machine_data.image}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins_server" {
  ami             = data.aws_ami.latest_jenkins_image.id # us-west-2
  instance_type   = var.jenkins_machine_data.type
  key_name        = var.key_pair_name
  subnet_id       = tolist(var.private_subnet_ids)[0]
  security_groups = [aws_security_group.jenkins_sg.id]
  tags = {
    "Name" = var.jenkins_machine_data.name
  }
  depends_on = [
    aws_security_group.jenkins_sg
  ]
}