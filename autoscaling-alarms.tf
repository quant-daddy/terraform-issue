# scale-up alarm

resource "aws_autoscaling_policy" "example-cpu-policy" {
  name = "example-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.example-autoscaling.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm" {
  alarm_name = "example-cpu-alarm"
  alarm_description = "example-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  period = "120"
  statistic = "Average"
  threshold = "30"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.example-autoscaling.name}"
  }
  actions_enabled = true
  # enable autoscaling when alarm is triggered
  alarm_actions = ["${aws_autoscaling_policy.example-cpu-policy.arn}", "${aws_sns_topic.example-sns.arn}"]
}



# scale-down alarm

resource "aws_autoscaling_policy" "example-cpu-policy-scaledown" {
  name = "example-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.example-autoscaling.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaledown" {
  alarm_name = "example-cpu-alarm-scaledown"
  alarm_description = "example-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  period = "120"
  statistic = "Average"
  threshold = 5
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.example-autoscaling.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.example-cpu-policy-scaledown.arn}"] #list of arns of actions
}
