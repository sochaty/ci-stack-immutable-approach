resource "aws_security_group" "public_instance_security_group" {
  name        = "Public-Instance-SG"
  description = "Internet access for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_security_group" "win_ec2_instance_security_group" {
  name        = "Win-Instance-SG"
  description = "Internet access for Win EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    protocol    = "TCP"
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_instance_security_group" {
  name        = "Private-Instance-SG"
  description = "Only allow internal instance to access these instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.public_instance_security_group.id]
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow traffic for health checking, remember this doesnt allow public internet!"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internet_lb_security_group" {
  name        = "PUBLIC-LB-SG"
  description = "Public LB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port = 0
    protocol  = "TCP"
    to_port   = 80
    security_groups = [aws_security_group.public_instance_security_group.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]    
  }

}

resource "aws_security_group" "internal_lb_security_group" {
  name        = "INTERNAL-lb-SG"
  description = "In ternal LB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to load balancer"
  }

  egress {
    from_port = 0
    protocol  = "TCP"
    to_port   = 80
    security_groups = [aws_security_group.private_instance_security_group.id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}
