locals {
  user_data_fe    = templatefile("${path.module}/include/user_data_fe.tpl", {
    envname         = var.envname
    lb_dns_endpoint = var.nlb_dns_endpoint
    fe_app_bucket   = data.terraform_remote_state.app_buckets.outputs.fe_app_bucket
  })
}

resource "aws_security_group" "fe_asg_sg" {
  name        = "cheetah-${var.envname}-fe-asg-sg"
  description = "Security group for ASG instances(frontend)."
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8501
    to_port         = 8501
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "fe_app_launch_template" {
  name_prefix   = "web-app-instance"
  image_id      = var.fe_ami_id
  instance_type = var.fe_instance_type

  user_data = base64encode(local.user_data_fe)
  key_name  = aws_key_pair.app_key_pair.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    subnet_id                   = var.subnet_id
    security_groups             = [aws_security_group.fe_asg_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "frontend_app_asg" {
  name                = "cheetah-${var.envname}-fe-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id = aws_launch_template.fe_app_launch_template.id
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "created_by"
    value               = "cheetah-${var.envname}-fe-asg"
    propagate_at_launch = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.frontend_app_asg.name
  lb_target_group_arn    = var.alb_tg_arn
}