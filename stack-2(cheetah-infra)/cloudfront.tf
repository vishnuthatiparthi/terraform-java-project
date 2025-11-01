module "cf" {
  source = "./localmodules/cloudfront"

  envname                                  = var.env_name
  comment                                  = "CloudFront Distribution For Datastore Application."
  alb_dns_name                             = module.alb.alb_dns_endpoint
  origin_id                                = var.origin_id
  default_behavior_allowed_methods         = var.default_behavior_allowed_methods
  default_behavior_cached_methods          = var.default_behavior_cached_methods
  default_behavior_forwarded_values_header = var.default_behavior_forwarded_values_header
}