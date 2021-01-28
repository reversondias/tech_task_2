resource "aws_launch_template" "instance_app_template" {
  name = "instance_app"
  description = "Template to create apps instances."

  instance_type = var.ec2_size_type

  key_name = var.key_pair_name
  image_id = data.aws_ami.ami.id
  instance_initiated_shutdown_behavior = "terminate"
  user_data = filebase64("${path.module}/userdata.sh")

  vpc_security_group_ids = [aws_security_group.ec2_app_sg.id,data.aws_security_groups.default_vpc_sg_id.ids[0]]

  disable_api_termination = false

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-acess-profile.name
  }

  # network_interfaces {
  #   delete_on_termination = true
  #   subnet_id = aws_subnet.private_subnet[0].id
  # }


  # tag_specifications {
  #   tags = {
  #     Name = var.ec2_name
  #   }
  # }


}