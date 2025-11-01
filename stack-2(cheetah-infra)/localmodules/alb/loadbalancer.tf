resource "aws_security_group" "alb_sg" {
  name = "cheetah-${var.envname}-alb-sg"
  description = "Security group for application load balancer."
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.fe_ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "cheetah-${var.envname}-frontend-tg"
  port     = 8501
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    port     = 8501
    path     = "/"
  }

  tags = {
    Name = "cheetah-${var.envname}-frontend-tg"
  }
}

resource "aws_lb" "alb" {
  name               = "cheetah-${var.envname}-frontend-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "cheetah-${var.envname}-frontend-alb"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}