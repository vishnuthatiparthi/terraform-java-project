module "lambda" {
  source = "./localmodules/lambda"

  envname             = var.env_name
  slack_web_hook_url  = var.slack_web_hook_url
  alert_sns_topic_arn = module.sns.alert_sns_topic_arn
}