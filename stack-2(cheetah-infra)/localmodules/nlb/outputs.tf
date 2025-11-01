output "nlb_dns_name" {
  value = aws_lb.net_lb.dns_name
}

output "nlb_sg_id" {
  value = aws_security_group.nlb_sg.id
}

output "nlb_tg_arn" {
  value = aws_lb_target_group.nlb_target_group.arn
}