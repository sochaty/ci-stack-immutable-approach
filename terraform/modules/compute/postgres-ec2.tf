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

resource "aws_instance" "postgres_server" {
  ami             = data.aws_ami.latest_postgres_image.id # us-west-2
  instance_type   = var.postgres_machine_data.type
  key_name        = var.key_pair_name
  subnet_id       = tolist(var.private_subnet_ids)[1]
  security_groups = [aws_security_group.postgres_sg.id]
  user_data = <<EOF
    #!/bin/bash
    sudo chmod 777 ~/../../etc/postgresql/14/main/pg_hba.conf
    echo '# IPv4 remote connections:' >> ~/../../etc/postgresql/14/main/pg_hba.conf
    echo 'host    all             all             0.0.0.0/0               scram-sha-256' >> ~/../../etc/postgresql/14/main/pg_hba.conf
  EOF
  tags = {
    "Name" = var.postgres_machine_data.name
  }
  depends_on = [
    aws_security_group.postgres_sg
  ]
}