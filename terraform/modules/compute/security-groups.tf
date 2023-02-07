resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-SG"
  description = "Jenkins EC2 instance security rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 22
  #   protocol    = "TCP"
  #   to_port     = 22
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port       = 22
    protocol        = "TCP"
    to_port         = 22
    security_groups = [aws_security_group.jumpbox_sg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nexus_sg" {
  name        = "Nexus-SG"
  description = "Nexus EC2 instance security rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8081
    protocol    = "TCP"
    to_port     = 8081
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8081
    protocol        = "TCP"
    to_port         = 8081
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  ingress {
    from_port       = 22
    protocol        = "TCP"
    to_port         = 22
    security_groups = [aws_security_group.jumpbox_sg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "SonarQube-SG"
  description = "SonarQube EC2 instance security rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    protocol        = "TCP"
    to_port         = 80
    security_groups = [aws_security_group.jenkins_sg.id]
    description     = "Traffic from jenkins sg"
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Traffic from internet"
  }

  ingress {
    from_port       = 22
    protocol        = "TCP"
    to_port         = 22
    security_groups = [aws_security_group.jumpbox_sg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "Postgres-SG"
  description = "Postgres EC2 instance security rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    protocol        = "TCP"
    to_port         = 5432
    security_groups = [aws_security_group.sonarqube_sg.id]
    description     = "Traffic from sonarqube sg"
  }

  ingress {
    from_port       = 22
    protocol        = "TCP"
    to_port         = 22
    security_groups = [aws_security_group.jumpbox_sg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "buildplatform_lb_security_group" {
  name        = "BuildPlatform-LB-SG"
  description = "BuildPlatform LB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port = 8080
    protocol  = "TCP"
    to_port   = 9000
    security_groups = [aws_security_group.jenkins_sg.id, aws_security_group.nexus_sg.id,
    aws_security_group.sonarqube_sg.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "jumpbox_sg" {
  name        = "JumpBox-SG"
  description = "JumpBox EC2 instance security rules"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
