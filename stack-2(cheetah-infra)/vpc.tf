module "vpc" {
  source = "./localmodules/vpc/"

  vpc_cidr = var.vpc_cidr
  env_name = var.env_name
}