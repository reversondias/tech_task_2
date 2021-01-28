resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_size

  health_check_grace_period = 300
  health_check_type         = "ELB"
  
  force_delete              = true

  launch_configuration      = aws_launch_configuration.instance_app_template.name
  vpc_zone_identifier       = tolist([for subnet_id in aws_subnet.private_subnet: subnet_id.id ])
  target_group_arns = [aws_lb_target_group.tg_group_app.arn]

  timeouts {
    delete = "15m"
  }

}