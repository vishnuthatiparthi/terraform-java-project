module "alb" {
  source = "./localmodules/alb/"

  envname = var.env_name
  vpc_id  = module.vpc.vpc_id
  fe_ingress_rules   = var.fe_ingress_rules
  public_subnet_ids = module.vpc.public_subnet_ids
}