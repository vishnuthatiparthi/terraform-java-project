locals {
  db_password = sensitive(data.aws_ssm_parameter.rds_db_password.value)
}

resource "aws_db_subnet_group" "private_sub_grp" {
  name       = "cheetah-${var.envname}-subnet-grp"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "cheetah-${var.envname}-subnet-grp"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "cheetah-${var.envname}-rds-sg"
  description = "Security group for RDS database."
  vpc_id      = var.rds_vpc_id

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
}

resource "aws_db_instance" "rds_db" {
  identifier          = "cheetah-${var.envname}-db-instance"
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = var.db_username
  password            = local.db_password
  db_subnet_group_name    = aws_db_subnet_group.private_sub_grp.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  deletion_protection     = false
  storage_encrypted       = true
  kms_key_id              = data.aws_kms_key.aws_managed_rds_key.arn

  tags = {
    Name = "cheetah-${var.envname}-db-instance"
  }
}