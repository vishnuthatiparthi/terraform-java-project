variable "envname" {
  type    = string
  default = ""
}

variable "rds_db_endpoint" {
  type    = string
  default = ""
}

variable "rds_db_uname" {
  type    = string
  default = ""
}

variable "rds_db_passwd" {
  type    = string
  default = ""
}

variable "jar_file" {
  type    = string
  default = ""
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "nlb_sg_id" {
  type    = string
  default = ""
}

variable "desired_capacity" {
  type    = number
  default = 0
}

variable "max_size" {
  type    = number
  default = 0
}

variable "min_size" {
  type    = number
  default = 0
}

variable "private_subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "nlb_tg_arn" {
  type    = string
  default = ""
}

variable "nlb_dns_endpoint" {
  type    = string
  default = ""
}

variable "alb_sg_id" {
  type    = string
  default = ""
}

variable "fe_ami_id" {
  type    = string
  default = ""
}

variable "fe_instance_type" {
  type    = string
  default = ""
}

variable "alb_tg_arn" {
  type    = string
  default = ""
}