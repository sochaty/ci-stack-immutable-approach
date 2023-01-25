
resource "aws_iam_role" "iam_role" {
  name               = "IAM-Role"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name = "IAM-Policy"
  role = aws_iam_role.iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "elasticloadbalancing:*",
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "IAM-Instance-Profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_launch_configuration" "public_launch_configuration" {
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  security_groups             = [aws_security_group.public_instance_security_group.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo service httpd start
    sudo chkconfig httpd on
    export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
    sudo chmod +x ../../var/www/html
    sudo echo "<html><body><h1>Public WebApp displaying INSTANCE ID => <b>"$INSTANCE_ID"</b> from public subnet</h1></body></html>" > /var/www/html/index.html
    sudo service httpd stop
    sudo service httpd start
  EOF

}

resource "aws_autoscaling_group" "public_autoscaling_group" {

  name                 = "Public-AutoScalingGroup"
  vpc_zone_identifier  = var.public_subnet_ids
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  launch_configuration = aws_launch_configuration.public_launch_configuration.name
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.internet_tg.arn]

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = var.environment
  }

  tag {
    key                 = "Type"
    propagate_at_launch = true
    value               = "Internet WebApp"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value = "${var.environment}-Public-Instance"
  }
}

resource "aws_autoscaling_policy" "public_scale_up_policy" {
  autoscaling_group_name   = aws_autoscaling_group.public_autoscaling_group.name
  name                     = "Public-AutoScaling-Policy"
  policy_type              = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

resource "aws_launch_configuration" "private_instance_launch_configuration" {
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  security_groups             = [aws_security_group.private_instance_security_group.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo service httpd start
    sudo chkconfig httpd on
    export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
    sudo chmod +x ../../var/www/html
    sudo echo "<html><body><h1>Private WebApp displaying INSTANCE ID => <b>"$INSTANCE_ID"</b> from private subnet</h1></body></html>" > /var/www/html/index.html
    sudo service httpd stop
    sudo service httpd start
  EOF
}

resource "aws_autoscaling_group" "private_autoscaling_group" {

  name                 = "Private-AutoScalingGroup"
  vpc_zone_identifier  = var.private_subnet_ids
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  launch_configuration = aws_launch_configuration.private_instance_launch_configuration.name
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.internal_tg.arn]

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = var.environment
  }

  tag {
    key                 = "Type"
    propagate_at_launch = true
    value               = "Internal WebApp"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value = "${var.environment}-Private-Instance"
  }
}

resource "aws_autoscaling_policy" "private_scale_up_policy" {
  autoscaling_group_name   = aws_autoscaling_group.private_autoscaling_group.name
  name                     = "Private-AutoScaling-Policy"
  policy_type              = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

data "aws_instances" "public_instances" {
  instance_tags = {
    Type = "Internet WebApp"
  }
  filter {
    name   = "instance.group-id"
    values = [aws_security_group.public_instance_security_group.id]
  }

  instance_state_names = [ "running", "stopped" ]
  depends_on           = [aws_autoscaling_group.public_autoscaling_group]
}

data "aws_instances" "private_instances" {
  instance_tags = {
    Type = "Internal WebApp"
  }
  filter {
    name   = "instance.group-id"
    values = [aws_security_group.private_instance_security_group.id]
  }

  instance_state_names = [ "running", "stopped" ]
  depends_on           = [aws_autoscaling_group.private_autoscaling_group]
}