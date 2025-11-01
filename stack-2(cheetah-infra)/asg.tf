module "asg" {
  source = "./localmodules/asg/"

  envname            = var.env_name
  rds_db_endpoint    = module.rds.rds_endpoint
  rds_db_uname       = var.db_username
  rds_db_passwd      = module.rds.rds_db_password
  jar_file           = var.jar_file
  ami_id             = "ami-08982f1c5bf93d976"
  instance_type      = var.instance_type
  subnet_id          = module.vpc.private_subnet_ids[0]
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  nlb_sg_id          = module.nlb.nlb_sg_id
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  private_subnet_ids = module.vpc.private_subnet_ids
  nlb_tg_arn         = module.nlb.nlb_tg_arn
  nlb_dns_endpoint   = module.nlb.nlb_dns_name
  alb_sg_id          = module.alb.alb_sg_id
  fe_ami_id          = "ami-08982f1c5bf93d976"
  fe_instance_type   = var.fe_instance_type
  alb_tg_arn         = module.alb.alb_tg_arn
}