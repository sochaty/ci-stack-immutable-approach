resource "aws_lb" "internet_load_balancer" {
  name               = "${var.environment}-Internet-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.buildplatform_lb_security_group.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "jenkins_tg" {
  name     = "${var.environment}-Jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = 8080
    path                = "/login"
    unhealthy_threshold = 5
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.internet_load_balancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "jenkins_tg_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = aws_instance.jenkins_server.id
  port             = 8080
  depends_on = [
    aws_instance.jenkins_server,
    aws_lb_target_group.jenkins_tg
  ]
}

resource "aws_lb_target_group" "nexus_tg" {
  name     = "${var.environment}-Nexus-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = 8081
    path                = ""
    unhealthy_threshold = 5
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "nexus_listener" {
  load_balancer_arn = aws_lb.internet_load_balancer.arn
  port              = "8081"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexus_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nexus_tg_attachment" {
  target_group_arn = aws_lb_target_group.nexus_tg.arn
  target_id        = aws_instance.nexus_server.id
  port             = 8081
  depends_on = [
    aws_instance.nexus_server,
    aws_lb_target_group.nexus_tg
  ]
}

resource "aws_lb_target_group" "sonarqube_tg" {
  name     = "${var.environment}-Sonarqube-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = 80
    path                = ""
    unhealthy_threshold = 5
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "sonarqube_listener" {
  load_balancer_arn = aws_lb.internet_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "sonarqube_tg_attachment" {
  target_group_arn = aws_lb_target_group.sonarqube_tg.arn
  target_id        = aws_instance.sonarqube_server.id
  port             = 80
  depends_on = [
    aws_instance.sonarqube_server,
    aws_lb_target_group.sonarqube_tg
  ]
}

