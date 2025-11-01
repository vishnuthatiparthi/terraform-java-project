module "cloudwatch" {
  source     = "./localmodules/cloudwatch"
  depends_on = [module.asg]

  envname       = var.env_name
  sns_topic_arn = module.sns.alert_sns_topic_arn
}