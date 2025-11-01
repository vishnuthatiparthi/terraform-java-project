locals {
  user_data   = templatefile("${path.module}/include/user_data_be.tpl", {
    envname         = var.envname
    rds_db_endpoint = var.rds_db_endpoint
    rds_db_uname    = var.rds_db_uname
    rds_db_passwd   = var.rds_db_passwd
    jar_file        = var.jar_file
    hook_name       = "instance-launch-hook"
    be_app_bucket   = data.terraform_remote_state.app_buckets.outputs.be_app_bucket
  })
}

resource "aws_key_pair" "app_key_pair" {
  key_name = "cheetah-${var.envname}-key"
  public_key = file("${path.module}/include/mykey.pub")
}

resource "aws_security_group" "asg_sg" {
  name        = "cheetah-${var.envname}-asg-sg"
  description = "Security group for ASG instances(backend)."
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8084
    to_port         = 8084
    protocol        = "tcp"
    security_groups = [var.nlb_sg_id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "cheetah-${var.envname}-access-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "backend_app_launch_template" {
  name_prefix          = "app-instance"
  image_id             = var.ami_id
  instance_type        = var.instance_type

  user_data            = base64encode(local.user_data)
  key_name             = aws_key_pair.app_key_pair.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    subnet_id                   = var.subnet_id
    security_groups             = [aws_security_group.asg_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend_app_asg" {
  name                 = "cheetah-${var.envname}-asg"
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.backend_app_launch_template.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  health_check_grace_period  = 300
  force_delete               = true
  wait_for_capacity_timeout  = "0"

  tag {
    key                 = "created_by"
    value               = "cheetah-${var.envname}-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.backend_app_asg.name
  lb_target_group_arn    = var.nlb_tg_arn
}

resource "aws_autoscaling_lifecycle_hook" "launch_hook" {
  name                   = "instance-launch-hook"
  autoscaling_group_name = aws_autoscaling_group.backend_app_asg.name
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
}

resource "aws_autoscaling_schedule" "app_be_ins_scale_up" {
  autoscaling_group_name = aws_autoscaling_group.backend_app_asg.name
  scheduled_action_name  = "be-app-instances-scaleup"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  recurrence             = "00 6 * * 1-5"
  time_zone              = "America/Virgin"
}

resource "aws_autoscaling_schedule" "app_be_ins_scale_down" {
  autoscaling_group_name = aws_autoscaling_group.backend_app_asg.name
  scheduled_action_name  = "be-app-instances-scaledown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "30 19 * * 1-5"
  time_zone              = "America/Virgin"
}