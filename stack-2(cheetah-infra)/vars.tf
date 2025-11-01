variable "env_name" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "rds_db_parameter_name" {
  type = string
  default = ""
}

variable "rds_ingress_rules" {
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
  type    = string
  default = ""
}

variable "jar_file" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "desired_capacity" {
  type    = number
  default = 0
}

variable "nlb_sg_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "max_size" {
  type    = number
  default = 0
}

variable "min_size" {
  type    = number
  default = 0
}

variable "slack_web_hook_url" {
  type    = string
  default = ""
}

variable "fe_instance_type" {
  type    = string
  default = ""
}

variable "fe_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "origin_id" {
  type    = string
  default = ""
}

variable "default_behavior_allowed_methods" {
  type    = list(string)
  default = [""]
}

variable "default_behavior_cached_methods" {
  type    = list(string)
  default = [""]
}

variable "default_behavior_forwarded_values_header" {
  type    = list(string)
  default = [""]
}