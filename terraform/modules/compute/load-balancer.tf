resource "aws_lb" "internet_load_balancer" {
  name               = "${var.environment}-Internet-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_lb_security_group.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "internet_tg" {
  name     = "${var.environment}-Internet-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = 80
    path                = "/index.html"
    unhealthy_threshold = 5
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "internet_load_balancer_listener" {
  load_balancer_arn = aws_lb.internet_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internet_tg.arn
  }
}

resource "aws_lb" "internal_load_balancer" {
  name               = "${var.environment}-Internal-LB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_lb_security_group.id]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false
  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "internal_tg" {
  name     = "${var.environment}-Internal-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 5
    interval            = 30
    port                = 80
    path                = "/index.html"
    unhealthy_threshold = 5
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "internal_load_balancer_listener" {
  load_balancer_arn = aws_lb.internal_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_tg.arn
  }
}

