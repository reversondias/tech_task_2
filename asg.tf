resource "aws_autoscaling_group" "app_asg" {
  name     = "app-asg"
  max_size = var.asg_max_size
  min_size = var.asg_min_size

  default_cooldown          = 60
  health_check_grace_period = 300
  health_check_type         = "ELB"

  force_delete = true

  vpc_zone_identifier = tolist([for subnet_id in aws_subnet.private_subnet : subnet_id.id])
  target_group_arns   = [aws_lb_target_group.tg_group_app.arn]

  launch_template {
    name = aws_launch_template.instance_app_template.name
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance-app"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "asg_app_policy_scale_in" {
  name                   = "asg-app-policy-scale-in"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  policy_type            = "SimpleScaling"
  cooldown               = 60
}

resource "aws_autoscaling_policy" "asg_app_policy_scale_out" {
  name                   = "asg-app-policy-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  policy_type            = "SimpleScaling"
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_utilization_in" {
  alarm_name          = "avg-cpu-utilization-asg-in"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.threshold_scale_in

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_app_policy_scale_in.arn]
}

resource "aws_cloudwatch_metric_alarm" "avg_cpu_utilization_out" {
  alarm_name          = "avg-cpu-utilization-asg-out"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = var.threshold_scale_out
  treat_missing_dara  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_app_policy_scale_out.arn]
}