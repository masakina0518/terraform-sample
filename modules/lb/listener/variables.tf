variable "project_name" {}

variable "environment" {}

variable "lb_this" {}

variable "lb_target_group_this" {}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {}
