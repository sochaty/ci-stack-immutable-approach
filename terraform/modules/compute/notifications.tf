resource "aws_sns_topic" "public-autoscaling-alert-topic" {
  display_name = "WebApp-AutoScaling-Topic"
  name         = "WebApp-AutoScaling-Topic"
}

resource "aws_sns_topic_subscription" "public-autoscaling-email-subscription" {
  endpoint  = "sourish.aws.23042019@gmail.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.public-autoscaling-alert-topic.arn
}

resource "aws_autoscaling_notification" "public-autoscaling-notification" {
  group_names = [aws_autoscaling_group.public_autoscaling_group.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
  topic_arn = aws_sns_topic.public-autoscaling-alert-topic.arn
}
