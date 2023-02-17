data "aws_ami" "latest_postgres_image" {
  most_recent = true
  owners      = ["${var.image_owner}"] # Canonical

  filter {
    name   = "name"
    values = ["${var.postgres_machine_data.image}-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_instance" "postgres_server_instance" {
  instance_id = aws_instance.postgres_server.id

  filter {
    name   = "tag:Name"
    values = [var.postgres_machine_data.name]
  }
}

resource "aws_instance" "postgres_server" {
  ami             = data.aws_ami.latest_postgres_image.id # us-west-2
  instance_type   = var.postgres_machine_data.type
  key_name        = var.key_pair_name
  subnet_id       = tolist(var.private_subnet_ids)[1]
  security_groups = [aws_security_group.postgres_sg.id]
  user_data       = file(var.postgres_user_script)  
  tags = {
    "Name" = var.postgres_machine_data.name
  }
  depends_on = [
    aws_security_group.postgres_sg
  ]
}