module "nlb" {
  source = "./localmodules/nlb/"

  envname            = var.env_name
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  ingress_rules      = var.nlb_sg_ingress_rules
}