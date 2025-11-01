module "rds" {
  source = "./localmodules/rds/"

  envname               = var.env_name
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_db_parameter_name = var.rds_db_parameter_name
  rds_vpc_id            = module.vpc.vpc_id
  ingress_rules         = var.rds_ingress_rules
  db_username           = var.db_username
}