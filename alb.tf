resource "aws_lb" "lb_app" {
  name               = "lb-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_app_sg.id,data.aws_security_groups.default_vpc_sg_id.ids[0]]
  subnets            = aws_subnet.public_subnet.*.id 

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "tg_group_app" {
  name     = "tg-group-app"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.company_vpc.id
  health_check {
      interval = 10
      path = "/"
      port = 80
      protocol = "HTTP"
      timeout = 5
      matcher = "200"
  }
}

resource "aws_lb_listener" "listner_app" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = "80"
  protocol          = "HTTP"

##### The correct way to do that is using HTTPS to security best practices. Below down there are right parameters to use with HTTPS. They are commented.
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "<certification SSL/TLS ARN>"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group_app.arn
  }
}