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

  network_interfaces {
    delete_on_termination = true
    #subnet_id = aws_subnet.private_subnet[0].id
  }


  # kernel_id = "test"

  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size = 20
  #   }
  # }

  # capacity_reservation_specification {
  #   capacity_reservation_preference = "open"
  # }

  # cpu_options {
  #   core_count       = 4
  #   threads_per_core = 2
  # }

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  # ebs_optimized = true

  # elastic_gpu_specifications {
  #   type = "test"
  # }

  # elastic_inference_accelerator {
  #   type = "eia1.medium"
  # }



  # instance_market_options {
  #   market_type = "spot"
  # }


  # license_specification {
  #   license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  # }

  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  # }

  # monitoring {
  #   enabled = true
  # }

  # network_interfaces {
  #   associate_public_ip_address = true
  # }

  # placement {
  #   availability_zone = "us-west-2a"
  # }

  # ram_disk_id = "test"


  # tag_specifications {
  #   tags = {
  #     Name = var.ec2_name
  #   }
  # }


}