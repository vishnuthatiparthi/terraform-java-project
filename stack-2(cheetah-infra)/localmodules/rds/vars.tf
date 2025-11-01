variable "envname" {
  type = string
  default = ""
}

variable "private_subnet_ids" {
  type = list(string)
  default = [""]
}

variable "rds_db_parameter_name" {
  type = string
  default = ""
}

variable "rds_vpc_id" {
  type = string
  default = ""
}

variable "ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "db_username" {
  type = string
  default = ""
}