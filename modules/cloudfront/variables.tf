variable "project_name" {}

variable "environment" {}

variable "lb_this" {}

variable "aliases" {}

variable "acm_certificate_arn" {}

# origin_id
locals {
  lb_origin_id = format("ELB-%s", split(".", var.lb_this.dns_name)[0])
}
