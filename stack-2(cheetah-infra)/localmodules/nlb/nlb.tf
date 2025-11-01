resource "aws_security_group" "nlb_sg" {
  name        = "cheetah-${var.envname}-nlb-sg"
  description = "Security group for network load balancer."
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
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

resource "aws_lb_target_group" "nlb_target_group" {
  name     = "cheetah-${var.envname}-backend-tg"
  port     = 8084
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    port     = 8084
    path     = "/actuator"
  }

  tags = {
    Name = "cheetah-${var.envname}-backend-tg"
  }
}

resource "aws_lb" "net_lb" {
  name               = "cheetah-${var.envname}-backend-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  enable_deletion_protection = false
  security_groups    = [aws_security_group.nlb_sg.id]

  tags = {
    Name = "cheetah-${var.envname}-backend-nlb"
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.net_lb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }
}