variable "envname" {
  type    = string
  default = ""
}

variable "comment" {
  type    = string
  default = ""
}

variable "alb_dns_name" {
  type    = string
  default = ""
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